# BagBoard - Setup Guide (Windows)

> **Easiest for anyone:** download **BagBoard.bat** and double-click it. It launches with no unzip, no install, and no admin. Everything below is the manual / from-source route.

BagBoard is a call CRM that runs on your computer at http://localhost:8753.
No login, no fees. You work leads on screen and dial them on your phone.

## Start it
Keep these two files together (e.g. a "BagBoard" folder on your Desktop):
- Start-BagBoard-Windows.bat   <- double-click this
- server.ps1 + index.html      <- the app (leave them together)

Double-click the .bat. A small black window opens and your browser opens BagBoard.
Keep the black window open while you work; close it to stop. First time only: if
Windows shows a blue "protected your PC" box, click More info -> Run anyway.
(If BagBoard is already running, double-clicking again just reopens it.)

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

## Sounds
Subtle audio cues fire on outcomes and milestones (off-switch in Settings). They are
generated in the browser - no files, nothing to install.

## Sharing on Wi-Fi (optional)
By default BagBoard is **private** — only your computer can open it. When it starts, it asks:
*"Share on your Wi-Fi?"* Press **Enter** to stay private, or type **Y** to let others on the same
network open it at the address shown (for example `http://192.168.1.20:8753`).

- The first time, Windows may ask you to allow it through the firewall — click **Allow**.
- Some guest/office Wi-Fi blocks device-to-device traffic; if a phone or laptop can't open the
  address, you're on such a network.
- **Only the app is shared, not the data.** Everyone who opens it gets their own private list on
  their own device — nothing syncs or merges. For your own pipeline, run your own copy.

## Back up your data
Your leads live in one browser, tied to the address you opened. In Settings -> Data, use
**Download backup** weekly (and Export CSV anytime). If you switch computers, or the shared
address changes, use **Restore from file** on the new copy. BagBoard reminds you when a backup
is due and shows where your data is stored.
