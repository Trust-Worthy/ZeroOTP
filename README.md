# ZeroOTP

**ZeroOTP** is a **privacy-first, open-source TOTP authenticator app** for iOS, built around zero trust principles and secure by default. It’s designed to be minimal, secure, offline, and completely in your control — no ads, no analytics, no nonsense.

This is my first serious iOS project as a junior developer, and a contribution to the open security community — inspired by tools like Aegis, FreeOTP, and the need for trustworthy, transparent apps in the mobile space.

---

## Why ZeroOTP?

Most 2FA/OTP apps today are either closed-source, overly complex, or collect telemetry under the hood. **ZeroOTP takes a different approach:**

- All OTP secrets are stored **securely in the iOS Keychain** (optionally using the **Secure Enclave** where available).
- Follows **Zero Trust** principles — never trusts input, environment, or device state without verification.
- No analytics, no trackers, no background data sync — works completely offline.
- Detects jailbroken or compromised devices and alerts users.
- Aims to be **clean, minimal, and auditable** — focused on doing one thing right.

---

## Features (Current)
- QR code scanning for automatic OTP setup
- Secure TOTP (Time-based One-Time Password) generation — RFC 6238 compliant
- Manual secret entry with Base32 validation
- Persistent storage of OTP accounts using `UserDefaults` (for now) + Keychain secrets
- Live OTP code refresh (every 30 seconds) — in progress
- Simple, clean UIKit interface with table view OTP listing
- Modular Swift architecture (Codable models, clear separation of logic)
- Fully offline, no external connections

---

## Coming Soon


- Use of **Secure Enclave** for protecting secrets on compatible devices
- HOTP support (counter-based OTPs per RFC 4226)
- Encrypted RAM / memory isolation of in-use secrets
- OTP export & encrypted backup
- SwiftUI port for future maintainability
- Optional end-to-end encrypted cloud sync (with full control)
- Support for **OpenMFA** protocols (push, passkeys, hardware tokens)

---

## What Zero Trust Means for 2FA

> Never trust — always verify.

Zero Trust applied to an authenticator app means:

- OTP secrets never leave your device
- No backups, no cloud sync (unless explicitly encrypted and user-enabled)
- Input is always validated (no malformed secrets, no assumptions)
- Your device is always questioned (jailbreak/root detection)
- You stay in control — no lock-in, no hidden behavior

---

## Roadmap

1. Core app with TOTP and secure local storage
2. Secure Enclave integration for top-tier hardware security
3. Live OTP refresh + countdown timer
4. QR code scanning + error correction
5. Encrypted, opt-in sync (iCloud, self-hosted, or none)
6. Expand to **OpenMFA** ecosystem (push auth, FIDO, passkeys, etc.)
7. Fully open-source infrastructure with transparency as the foundation

---

## Tech Stack

- Swift + UIKit
- SwiftOTP (for TOTP generation)
- Keychain & Secure Enclave APIs
- Codable for secure data modeling
- UserDefaults (temporary, in transition to secure persistence)

---

## License

[MIT License](LICENSE) — free to use, modify, and improve.

---

## Contributing

PRs, issues, and feedback welcome — especially around:

- Security review
- UI/UX polish
- Swift best practices
- Bug fixes or feature suggestions


