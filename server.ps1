# BagBoard local server - serves index.html at http://localhost:8753
$port = 8753
$root = $PSScriptRoot
if ([string]::IsNullOrEmpty($root)) { $root = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$htmlPath = Join-Path $root 'index.html'
$url = "http://localhost:$port/"
if (-not (Test-Path $htmlPath)) { Clear-Host; Write-Host '  index.html not found next to this script.' -ForegroundColor Red; Read-Host '  Press Enter'; exit 1 }
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port)
try { $listener.Start() } catch { Start-Process $url; exit 0 }
Start-Process $url
Clear-Host; Write-Host ''; Write-Host '  BagBoard is running at ' -NoNewline; Write-Host $url -ForegroundColor Green
Write-Host '  Keep this window open. Close it to stop.'; Write-Host ''
$htmlBytes = [System.IO.File]::ReadAllBytes($htmlPath)
while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream(); $buffer = New-Object byte[] 4096
        try { [void]$stream.Read($buffer, 0, $buffer.Length) } catch {}
        $header = "HTTP/1.1 200 OK`r`nContent-Type: text/html; charset=utf-8`r`nContent-Length: $($htmlBytes.Length)`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($hb,0,$hb.Length); $stream.Write($htmlBytes,0,$htmlBytes.Length); $stream.Flush()
    } catch { } finally { $client.Close() }
}
