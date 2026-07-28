#!/bin/bash
# BagBoard launcher for macOS — the Mac twin of BagBoard.bat.
#
# Double-click this file to run it. The first time, macOS may say it's from an
# unidentified developer: right-click the file -> Open -> Open, just once.
# (Or from Terminal: chmod +x Start-BagBoard-Mac.command && ./Start-BagBoard-Mac.command)
#
# It installs to ~/bagboard, downloads the latest app, and starts the local
# server so your phone can sync. Ruby ships with macOS (including Apple Silicon
# M1/M2/M3/M4), so there is nothing to install. Keep the window open while you
# work; close it or press Ctrl-C to stop.

set -u
BASE="https://raw.githubusercontent.com/JAMMx2/bagboard/main"
DIR="$HOME/bagboard"
mkdir -p "$DIR" || { echo "Could not create $DIR"; read -r -p "Press Return to close "; exit 1; }
cd "$DIR" || exit 1

echo ""
echo "  Downloading the latest BagBoard..."
if ! curl -fsSL "$BASE/index.html" -o index.html; then
  echo "  Could not download BagBoard. Check your internet connection and try again."
  read -r -p "  Press Return to close "
  exit 1
fi

if command -v ruby >/dev/null 2>&1; then
  curl -fsSL "$BASE/server.rb" -o server.rb
  exec ruby server.rb
else
  # Ruby not found (rare) — fall back to the zero-dependency standalone app.
  echo "  Ruby isn't available, so phone sync is off — opening BagBoard in standalone mode."
  echo "  (Your leads are saved in this browser on this Mac.)"
  open index.html
fi
