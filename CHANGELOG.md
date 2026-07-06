# Changelog

## 1.2.0 — 2026-07

- **Add notes anywhere.** A note box right on the dial screen and the lead view — no digging through menus.
- **Full call & note memory.** Each lead shows a timeline of every dial, its outcome, and every note, newest first.
- **One-tap quick texts.** Fire the right follow-up (voicemail, callback, appt, quote, thanks) straight from the dialer.
- **Bigger wins.** Confetti and a punchy moment when you close or set an appointment, plus "on fire" streak call-outs.


- **Dial from your phone (pairing).** Run the launcher, share on Wi-Fi, open the address on your phone, and dial the SAME leads from your phone with your own number — outcomes sync both ways.
- **Shared database.** The Windows launcher now stores leads in a local file (`%USERPROFILE%\BagBoard-data.json`) and serves a token-gated `/api/state` endpoint, so the computer and phone share one live list (and data survives a browser-cache wipe). Opening `index.html` as a plain file remains the offline, per-device mode.
- **Pair-your-phone screen** with an optional "number you dial from" field.
- **Smarter CSV import.** Auto-detects the name, phone and other columns from almost any CRM export, ignores decoy columns (policy numbers, dates, emails, disposition tags like "YES"/"WARM"), strips `+1` and formatting, de-dupes, preserves any unmapped columns and a Notes/Comments column into each lead's Notes (nothing is dropped), and reports how many rows were skipped.
- Security & docs updated for the LAN sync posture (trusted networks only).

## 1.0.1 — 2026-07-01

- **Shared-address awareness:** BagBoard now shows a banner when you're running off a shared Wi-Fi
  address (where your leads are actually saved), so data doesn't appear to "vanish" if that address
  later changes.
- **Backup reminder:** a gentle, dismissible nudge when a backup is due, plus your last-backup time
  and where your data is stored, shown in Settings -> Data.
- **Launcher:** clearer startup output (firewall prompt, guest-Wi-Fi client-isolation note, and a
  reminder that only the app is shared, not the data). Re-running while it's already open now just
  reopens it instead of erroring.
- **Docs:** new "Multiple people / same Wi-Fi" guidance in the README and setup guide.

## 1.0.0 — 2026-06-30

First public release.

- Single-file, offline call CRM. Data stored in localStorage; no backend, no accounts, no fees.
- Power Session dialer with prioritized queue; hand-dial friendly (tap-to-call on phones, copy-number on desktop).
- **Rapid Dial** mode: blitz the whole list — big number, tap to copy, Spacebar for next, keys 1-5 for quick outcomes, and optional hands-free auto-advance (1-4s).
- Lead pipeline: stages, scheduled follow-ups, notes; search, sort, filter, multi-select, de-dupe.
- Agenda view (overdue / today / upcoming) and an appointment field on leads.
- Stats: contact & appointment rates, 7-day dials-vs-contacts chart, pipeline by stage, personal bests, and a rank.
- Engagement: daily-goal ring, day streak, in-session momentum meter, milestone moments.
- Synthesized (Web Audio) sound cues with an on/off toggle — no audio files.
- CSV import (paste or file), CSV export, JSON backup/restore.
- One-file **BagBoard.bat** double-click launcher (contains the whole app; no unzip, no install, no admin) plus a PowerShell server for running from source.
- Private by default (localhost only); opt in at startup to share on your Wi-Fi so others on the same network can open it.
