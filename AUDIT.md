# Pre-Release Security & Quality Audit — BagBoard

**Date:** 2026-06-30  **Target:** `index.html` (single-file app, 71228 bytes) + Windows launcher
**Method:** automated scans (network/secrets/sinks/deps) + an independent line-by-line security & code review + an automated test suite (21 functional checks, all passing).

## Verdict
**Cleared for open-source release under MIT.** No XSS, no network/exfiltration, no embedded
secrets or real PII, no `eval`-class sinks, and zero third-party dependencies.

## What was checked

### Security — PASS
- **HTML injection / XSS:** Every user-controlled value (lead name, phone, product, company,
  source, value, note bodies, agent name, editable text templates) is HTML-escaped via `esc()`
  before reaching `innerHTML`, in both text and attribute positions. No unescaped user-data sink found.
- **Network / exfiltration:** No `fetch`/XHR/WebSocket/beacon/analytics and no external scripts,
  fonts, or CDNs. The only outbound links are `tel:`/`sms:` (native dialer/Messages). Fully offline.
- **Secrets / PII:** None embedded. Sample data is fictional 555 numbers. Storage key is a plain string.
- **Dangerous patterns:** No `eval`, `new Function`, or `document.write`. `innerHTML` is the only sink.
- **Windows launcher (`server.ps1`):** Binds to `127.0.0.1` only; always serves the local app file
  (no request-path → filesystem mapping), so no directory traversal. Runs under the user's own account.

### Privacy — PASS
All data stays in the browser's localStorage on the user's device. Nothing is transmitted.

### Dependencies / licensing — PASS
No runtime dependencies. Original code and content. Released under MIT (see LICENSE).

## Fixes applied during the audit
1. **Accessibility — zoom re-enabled.** Removed `maximum-scale=1, user-scalable=no` (WCAG 1.4.4).
2. **Accessibility — labels.** Added `aria-label` to icon-only header buttons; the sound toggle is now
   `role="switch"` with `aria-checked`.
3. **Robust restore.** Loading/restoring a backup now runs through `normalize()`, which validates that
   `leads`/`calls` are arrays, restores missing config objects, clamps each lead's `stage` to a known
   value, and coerces `value`/`notes` — so a corrupt or hand-edited file can't white-screen the app.
4. **Defense-in-depth escaping.** Stage/outcome display fallbacks are now `esc()`-wrapped.
5. **No silent data loss.** `save()` shows a toast if `localStorage` is full or disabled.
6. **Minor cleanup.** Removed a dead conditional in CSV import.

## Residual recommendations (non-blocking, nice-to-have)
- Modal sheets could add `role="dialog"`, focus-trap, and Escape-to-close for fuller a11y.
- Add a state-version/migration scheme if the saved data shape changes in future releases.

## v1.1.0 addendum (2026-07) — optional Wi-Fi sync
The app gained an optional shared-database mode. Launched via the server with sharing on, it makes
**same-origin** `fetch` calls to a **token-gated** `/api/state` endpoint served by the local launcher,
which persists leads to `%USERPROFILE%\BagBoard-data.json`. Notes: (1) opened as a plain file the app is
still fully offline (no network); (2) in shared mode leads are readable/writable by LAN devices holding
the link (token gate only, not strong auth), so it is documented as trusted-network-only; (3) the
launcher still serves the single app for any non-API path (no path traversal), and a POST only ever
overwrites the one data file. No third-party code or external network calls were introduced.
