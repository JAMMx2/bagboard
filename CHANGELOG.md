# Changelog

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
