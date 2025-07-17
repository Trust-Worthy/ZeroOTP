# ZeroOTP

ZeroOTP is a **privacy-first, open-source TOTP authenticator app** designed with zero trust principles. It’s built to provide secure, reliable, and private OTP generation without compromising your data or device security.

This project is my first serious dive into iOS development — a junior dev’s hands-on effort to contribute to the open security community with a clean, minimal, and trustworthy app.

---

## Why ZeroOTP?

Most OTP apps are either closed-source or collect unnecessary user data for analytics and push notifications. ZeroOTP aims to:

- Store all OTP secrets securely on-device in the iOS Keychain — never transmitted or backed up in plain text.
- Minimize app permissions and avoid any unnecessary data collection.
- Validate inputs strictly to avoid vulnerabilities.
- Detect jailbroken/rooted devices to warn users of potential risks.
- Apply zero trust principles: never implicitly trust data or environment.
- Keep the UI simple, functional, and user-friendly.

---

## Features (Planned / In Progress)

- Secure TOTP and HOTP generation following RFC 6238 / 4226
- QR code and manual secret entry with validation
- Local-only secret storage in Keychain
- Jailbreak/root detection
- No user tracking or analytics
- Clear, open-source Swift codebase for community review and contributions

---

## What is Zero Trust for OTP apps?

Zero Trust means **never trust anything implicitly** — always verify, authenticate, and secure at every step:

- Secrets never leave your device.
- Strict input validation prevents malicious data.
- Minimal app permissions reduce attack surface.
- Environment checks prevent running on compromised devices.
- Encrypted communication for any server sync (future feature).

---

## Roadmap

1. Build the core ZeroOTP app (TOTP & HOTP)
2. Add support for encrypted cloud sync (end-to-end encrypted)
3. Expand into **OpenMFA** — a broader multi-factor authentication platform supporting push notifications, hardware keys, passkeys, and more


## License

MIT License

---
