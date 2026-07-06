# Security Policy

BagBoard is a **client-side** app. Opened as a plain file it has no server and makes no network
requests — all data lives in your browser's localStorage on your own device. Launched via the
optional Windows server it also syncs to a small local database (see the Wi-Fi sync note below). Calls and
texts use your phone's native `tel:`/`sms:` handlers; on a computer the app copies to the
clipboard. Nothing is transmitted anywhere.

## Reporting a vulnerability
Please open a **private security advisory** (or a regular issue if minor) on the project's
GitHub repository. Include steps to reproduce and affected browser/OS. We'll respond as
soon as we can.

## Scope notes
- The only HTML sink is `innerHTML`; all user-controlled values are HTML-escaped via `esc()`.
- Restored backup files are normalized/validated before use (`normalize()`).
- The optional Windows launcher (`server.ps1`) binds to `127.0.0.1` (private) by default. You may
  opt in at startup to share on your local network, which binds to your LAN address so other devices
  on the same Wi-Fi can open the app. It always serves the single app file for any request (no
  request-path-to-file mapping, so no path traversal), and no user data is transmitted — each
  viewer's leads stay in their own browser.
- Wi-Fi sharing has no password by design: the launcher serves **only the app file** over plain
  HTTP on your LAN, and never sends or stores data server-side, so there's nothing to authenticate
  to. Keep it **private** (the default) on public/guest networks and only share on networks you trust.
- **Wi-Fi sync (v1.1):** when you run the launcher and opt into sharing, the app talks to the local
  BagBoard server over a **same-origin, token-gated** `/api/state` endpoint, and the server stores leads
  in `%USERPROFILE%\BagBoard-data.json`. While shared, any device on your LAN that has the link can
  read/write that data — this is a convenience gate, not strong auth. Use sharing only on **trusted**
  networks and keep BagBoard **private** (the default) on public/guest Wi-Fi. Opened as a plain file,
  the app remains fully offline with no network calls.
