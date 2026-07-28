#!/usr/bin/env ruby
# frozen_string_literal: true
#
# BagBoard local server (macOS / Linux) — serves index.html + a shared leads
# database (/api/state). Private (localhost) by default; opt in at startup to
# share on your Wi-Fi so your phone syncs. This is the cross-platform twin of
# server.ps1 — it uses only Ruby's standard library, which ships with macOS
# (including Apple Silicon M1/M2/M3/M4), so there is nothing to install.
#
#   ruby server.rb            # run it
#   BB_NO_OPEN=1 ruby ...     # don't auto-open a browser (used by tests)
#   BB_SHARE=Y  ruby ...      # answer the Wi-Fi prompt non-interactively

require 'socket'
require 'securerandom'

STDOUT.sync = true # show the status banner immediately in Terminal

# Clean exit on Ctrl-C (so the copy-paste launcher doesn't treat it as a crash)
trap('INT')  { puts; puts '  BagBoard stopped.'; exit 0 }
trap('TERM') { exit 0 }

PORT      = (ENV['BB_PORT'] || '8753').to_i
ROOT      = __dir__ || File.expand_path('.')
HTML_PATH = File.join(ROOT, 'index.html')
DATA_PATH = File.join(Dir.home, 'BagBoard-data.json')

def color(text, code) # tiny ANSI helper; harmless if the terminal ignores it
  "\e[#{code}m#{text}\e[0m"
end

def open_browser(url)
  return if ENV['BB_NO_OPEN'] == '1'
  if RUBY_PLATFORM =~ /darwin/
    system('open', url)
  elsif system('command -v xdg-open >/dev/null 2>&1')
    system('xdg-open', url)
  end
rescue StandardError
  # opening a browser is a nicety, never fatal
end

# Best-effort LAN IPv4 so a phone on the same Wi-Fi can reach us.
def lan_ip
  %w[en0 en1 en2 en3].each do |iface|
    ip = `ipconfig getifaddr #{iface} 2>/dev/null`.to_s.strip
    return ip unless ip.empty?
  end
  begin
    s = UDPSocket.new
    s.connect('192.168.0.1', 1) # picks the default route; sends nothing
    ip = s.addr.last
    s.close
    return ip if ip && !ip.empty? && ip != '127.0.0.1'
  rescue StandardError
    nil
  end
  nil
end

unless File.exist?(HTML_PATH)
  puts color('  index.html not found next to this script.', 31)
  print '  Press Enter to close '
  STDIN.gets
  exit 1
end

puts
puts color('  BagBoard', 32)
puts '  By default only THIS computer can open it (private).'

answer = ENV['BB_SHARE']
if answer.nil?
  print '  Share on your Wi-Fi so your phone can open it and dial? Type Y, or press Enter for private: '
  answer = STDIN.gets
end
shared = answer.to_s.strip =~ /\A[Yy]/ ? true : false
lan    = shared ? lan_ip : nil
bind   = shared ? '0.0.0.0' : '127.0.0.1'

begin
  server = TCPServer.new(bind, PORT)
rescue Errno::EADDRINUSE, Errno::EACCES
  puts
  puts color('  BagBoard is already running on this computer — opening it.', 32)
  open_browser("http://localhost:#{PORT}/")
  sleep 1
  exit 0
end

open_browser("http://localhost:#{PORT}/")

puts
puts color('  BagBoard is running', 32)
puts
puts "  On this computer: http://localhost:#{PORT}/"
if shared
  if lan
    puts color("  On your phone (Wi-Fi): http://#{lan}:#{PORT}/", 33)
    puts
    puts '  Open that address on your phone to dial — your leads sync both ways.'
    puts '  - Use a network you trust (home/office), not public Wi-Fi.'
    puts '  - Some guest/office Wi-Fi blocks device-to-device traffic; if the phone'
    puts '    cannot open it, you are on such a network.'
  else
    puts color('  Sharing on Wi-Fi — run `ipconfig getifaddr en0` to find your address.', 33)
  end
else
  puts '  Private — only this computer can open it (data saved on this Mac).'
end
puts
puts '  Keep this window open while you work. Close it (or press Ctrl-C) to stop.'
puts

TOKEN = SecureRandom.hex(5) # 10 hex chars, matches server.ps1

tag = +"<script>window.BB_STORE='/api/state?k=#{TOKEN}';"
tag << "window.BB_SHARE='http://#{lan}:#{PORT}/';" if shared && lan
tag << '</script>'

html_text  = File.read(HTML_PATH, mode: 'rb').force_encoding('UTF-8')
html_text  = html_text.sub('</head>', "#{tag}</head>")
HTML_BYTES = html_text.b # bytes to serve

def send_response(client, status, ctype, body_bytes)
  header = +"HTTP/1.1 #{status}\r\n"
  header << "Content-Type: #{ctype}\r\n"
  header << "Content-Length: #{body_bytes.bytesize}\r\n"
  header << "Cache-Control: no-store\r\n"
  header << "Connection: close\r\n\r\n"
  client.write(header.b)
  client.write(body_bytes)
  client.flush
end

loop do
  client = server.accept
  Thread.new(client) do |sock|
    begin
      request_line = sock.gets
      next unless request_line

      method, path, = request_line.split(' ')
      method ||= 'GET'
      path   ||= '/'

      content_length = 0
      while (line = sock.gets) && line != "\r\n"
        content_length = Regexp.last_match(1).to_i if line =~ /\Acontent-length:\s*(\d+)/i
      end

      if path.start_with?('/api/state')
        if !path.include?("k=#{TOKEN}")
          send_response(sock, '403 Forbidden', 'application/json', '{"error":"forbidden"}'.b)
        elsif method == 'POST'
          body = content_length.positive? ? sock.read(content_length) : ''
          begin
            File.open(DATA_PATH, 'wb') { |f| f.write(body.to_s) }
          rescue StandardError
            nil
          end
          send_response(sock, '200 OK', 'application/json', '{"ok":true}'.b)
        else
          data = File.exist?(DATA_PATH) ? File.binread(DATA_PATH) : '{}'.b
          send_response(sock, '200 OK', 'application/json', data)
        end
      else
        send_response(sock, '200 OK', 'text/html; charset=utf-8', HTML_BYTES)
      end
    rescue StandardError
      # one bad connection should never take down the server
    ensure
      sock.close rescue nil
    end
  end
end
