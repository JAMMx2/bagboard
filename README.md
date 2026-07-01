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

## Get it running — one double-click

**Windows (easiest):** download **[`BagBoard.bat`](https://github.com/JAMMx2/bagboard/releases/latest/download/BagBoard.bat)** and **double-click it**. That's the whole setup — it launches and opens in your browser. No unzip, no install, no admin. *(If Windows shows a "protected your PC" box the first time, click **More info → Run anyway**.)*

**Any computer or phone:** download **[index.html](https://github.com/JAMMx2/bagboard/raw/main/index.html)** and open it in any browser — that's the entire app.

**Whole project (developers):** grab **[the latest release](https://github.com/JAMMx2/bagboard/releases/latest)** (`bagboard.zip`) or clone the repo. `SETUP-GUIDE.md` has step-by-step instructions.

> First thing in the app: open **Settings**, set your name, then **Add** or **Import** your leads.

**Sharing on your network (optional):** it's private by default — only your computer can open it. At startup you can type **Y** to share it on your Wi-Fi so others on the same network open it at the address shown (e.g. `http://192.168.1.20:8753`). Only the app is shared; each person's leads stay on their own device.

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
