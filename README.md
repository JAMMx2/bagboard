<div align="center">

# BagBoard

**A single-file call CRM. No login, no servers, no monthly fees.**
Your leads live in your own browser; you dial them from your own phone.

[![Download](https://img.shields.io/badge/Download-v1.0.0-2ea44f?style=for-the-badge)](https://github.com/JAMMx2/bagboard/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-3b82f6?style=for-the-badge)](LICENSE)
![Single file](https://img.shields.io/badge/single_file-~71_KB-6b7280?style=for-the-badge)
![No dependencies](https://img.shields.io/badge/dependencies-none-2ea44f?style=for-the-badge)

![BagBoard preview](preview.svg)

</div>

## Download & run — about 30 seconds

**Windows (easiest):** grab **[the latest release](https://github.com/JAMMx2/bagboard/releases/latest)**, unzip `bagboard.zip`, and double-click **`Start-BagBoard-Windows.bat`**. Your browser opens the app at `http://localhost:8753`. No install, no admin.

**Any computer:** download **[index.html](https://github.com/JAMMx2/bagboard/raw/main/index.html)** and open it in any browser — that's the whole app.

**One-file option:** download **`BagBoard-Installer.ps1`** from the release, right-click → *Run with PowerShell*, and it rebuilds and launches everything from that single file.

> First thing in the app: open **Settings**, set your name, then **Add** or **Import** your leads.

## What it does
- Lines up who to call next and walks you through them one at a time — number, outcome, next.
- Full pipeline: New → Contacted → Callback → Appt → Quoted → Closed, with follow-ups scheduled for you.
- Hand-dial friendly: tap-to-call on a phone; on a computer it copies the number to dial by hand and copies a ready-to-send follow-up text.
- Search, sort, filter, multi-select, de-dupe. An agenda of what's due. Stats: contact/appointment rates, a 7-day chart, pipeline, and personal bests.
- Stays motivating — a daily-goal ring, streaks, in-session momentum, and subtle (toggleable) sound cues.
- CSV import/export and one-click local backup. **Nothing ever leaves your machine.**

## Your data & privacy
Everything is stored in your browser's `localStorage` on the device you use — no accounts, no network calls, no tracking. Clearing your browser wipes it, so use **Settings → Download backup** now and then. See [SECURITY.md](SECURITY.md) and the [security audit](AUDIT.md).

## Contributing
It's intentionally one file of vanilla HTML/CSS/JS — no build step, no dependencies. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
[MIT](LICENSE) — do what you want with it. © 2026 BagBoard contributors
