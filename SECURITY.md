# Security Policy

BagBoard is a **client-side** app. It has no server, no accounts, and makes no network
requests — all data lives in your browser's localStorage on your own device. Calls and
texts use your phone's native `tel:`/`sms:` handlers; on a computer the app copies to the
clipboard. Nothing is transmitted anywhere.

## Reporting a vulnerability
Please open a **private security advisory** (or a regular issue if minor) on the project's
GitHub repository. Include steps to reproduce and affected browser/OS. We'll respond as
soon as we can.

## Scope notes
- The only HTML sink is `innerHTML`; all user-controlled values are HTML-escaped via `esc()`.
- Restored backup files are normalized/validated before use (`normalize()`).
- The optional Windows launcher (`server.ps1`) binds to `127.0.0.1` only and always serves
  the local app file (no request-path-to-file mapping, so no path traversal).
