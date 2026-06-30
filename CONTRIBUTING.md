# Contributing to BagBoard

Thanks for your interest! BagBoard is intentionally **one file** (`index.html`) of
vanilla HTML/CSS/JS — no framework, no build step, no dependencies. Please keep it
that way: no npm packages, no CDN includes, no external calls.

## Run it
Open `index.html` in any browser. That's the whole dev loop. (On Windows you can
also double-click `Start-BagBoard-Windows.bat` to run it at http://localhost:8753.)

## Guidelines
- Keep it dependency-free and offline-only. All data stays in the browser's localStorage.
- Escape every piece of user-controlled data with `esc()` before putting it in `innerHTML`.
- Match the existing style: flat, restrained, one accent color, hairline dividers.
- Test in a browser before opening a PR: add leads, run a Power Session, import/export a CSV, restore a backup.

## Reporting bugs
Open an issue with steps to reproduce and your browser/OS.
