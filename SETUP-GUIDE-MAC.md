# BagBoard - Setup Guide (macOS)

> **Easiest for anyone:** download **Start-BagBoard-Mac.command** and double-click it.
> The first time only, **right-click it → Open → Open** (macOS asks once about an
> unidentified developer). Everything below is the manual / from-source route.

BagBoard is a call CRM that runs on your Mac at http://localhost:8753.
No login, no fees. You work leads on screen and dial them on your phone.

**Works on every Mac, including Apple Silicon (M1 / M2 / M3 / M4).** Ruby already
ships with macOS, so there is nothing to install and nothing to download from Apple.
(The Windows `BagBoard.bat` will **not** run on a Mac — use the `.command` file or the
Terminal command below instead.)

## Start it — the one-line way (copy-paste into Terminal)
Open **Terminal** (press ⌘-Space, type "Terminal", Enter) and paste:

```bash
d=~/bagboard; mkdir -p "$d" && curl -fsSL https://raw.githubusercontent.com/JAMMx2/bagboard/main/index.html -o "$d/index.html" && curl -fsSL https://raw.githubusercontent.com/JAMMx2/bagboard/main/server.rb -o "$d/server.rb" && cd "$d" && ruby server.rb
```

Your browser opens BagBoard and Terminal asks about Wi-Fi sharing. Keep the Terminal
window open while you work; close it or press **Ctrl-C** to stop. Re-run any time with
`cd ~/bagboard && ruby server.rb`.

## Start it — the double-click way
Keep these files together (e.g. a "BagBoard" folder in your home folder):
- `Start-BagBoard-Mac.command` <- double-click this
- `server.rb` + `index.html` <- the app (leave them together)

Double-click `Start-BagBoard-Mac.command`. Terminal opens and your browser opens
BagBoard. **First time only:** if macOS says it's from an unidentified developer,
**right-click the file → Open → Open** (you only do this once). Keep the Terminal
window open while you work; close it to stop. If BagBoard is already running,
double-clicking again just reopens it.

## Just want it open, no server?
One line, works on every Mac, saves your leads in that browser on this Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/JAMMx2/bagboard/main/index.html -o ~/BagBoard.html && open ~/BagBoard.html
```

## First five minutes
1. Settings (gear, top-right): type your name, set daily targets, toggle Sounds, Save.
2. Add leads: the + button -> New lead, Import from CSV file, or Paste a list.
3. Tap Call (bottom bar) to start a session. For each lead: click the number to copy
   it, dial on your phone, talk, then click the outcome. BagBoard schedules the
   follow-up, builds your momentum, and moves to the next one.
4. Texting: Copy text -> pick a message -> paste and send from your phone.

## The screens
- Home - a daily-goal ring, your streak, who to call next.
- Leads - search, sort, filter; tap Select for bulk actions.
- Agenda - appointments and follow-ups by day.
- Stats - contact/appt rates, a 7-day chart, pipeline, and your personal bests.

## Sharing on Wi-Fi (optional)
By default BagBoard is **private** — only your Mac can open it. When it starts, it asks
*"Share on your Wi-Fi?"* Press **Enter** to stay private, or type **Y** to let your phone
(same network) open it at the address shown (for example `http://192.168.1.20:8753`).

- The first time, macOS may ask you to allow incoming connections — click **Allow**.
- Some guest/office Wi-Fi blocks device-to-device traffic; if your phone can't open the
  address, you're on such a network.
- Leads sync both ways between your Mac and phone through a token-gated `/api/state`
  endpoint. Use a **trusted** network and back up regularly.

## Back up your data
When you run the server, your leads are saved to `~/BagBoard-data.json` in your home
folder (that's what the phone syncs with). In Settings -> Data, use **Download backup**
weekly (and Export CSV anytime). In standalone mode (opening `index.html` directly), your
leads live in that one browser — back up the same way.
