# ZeroOTP

**ZeroOTP** is a **privacy-first, open-source TOTP authenticator app** for iOS, built around zero trust principles and secure by default. It’s designed to be minimal, secure, offline, and completely in your control — no ads, no analytics, no nonsense.

---

## App Evaluation

### Mobile
- Uses QR code scanning via camera, secure credential storage in iOS Keychain, and optionally Secure Enclave.
- Fully offline functionality — no background sync, no external network requests.
- Jailbreak detection for device integrity.

### Story
- Designed to empower users who value privacy and want control over their 2FA secrets.
- Clear narrative: “You own your keys. You own your identity.”
- Strong appeal to developers, privacy advocates, and open-source supporters.

### Market
- Growing niche in open-source security tools.
- Competes with Google Authenticator, Authy, FreeOTP, and Aegis.
- Addresses the need for an **open, auditable, iOS-native** OTP solution.

### Habit
- Opened frequently for daily logins; moderate engagement.
- Mostly consumption-based (viewing OTP codes), with periodic creation (adding new OTPs).

### Scope
- MVP well-scoped: OTP generation, QR scanning, secure local storage.
- Stretch goals (Secure Enclave, encrypted backups, sync) extend functionality without blocking MVP.

---

## App Spec

### Required Features
- ✅ Add new OTP account by scanning QR code
- ✅ Manual entry of OTP secrets (with validation)
- ✅ View and copy current TOTP codes
- ✅ Secrets stored securely in iOS Keychain
- ✅ Timer refresh for codes every 30 seconds
- ✅ Jailbreak detection warning

### Optional Features
- 🔒 Secure Enclave integration
- 🔁 Encrypted export/backup
- ☁️ End-to-end encrypted cloud sync (optional)
- 💬 User education modal: “What is 2FA / TOTP?”

---

## Screens

1. **Main OTP List Screen**
   - Lists saved OTP accounts
   - Shows TOTP code with live countdown
   - Copy button for each code

2. **Add OTP Screen**
   - Option to scan QR code or enter secret manually
   - Base32 input field with validation
   - Account name input

3. **QR Scanner Screen**
   - Access camera
   - Parse `otpauth://` URI scheme

4. **Settings Screen**
   - Export/import (optional)
   - About / credits / license
   - Jailbreak warning toggle

5. **Onboarding / Info Screen** *(optional)*
   - Intro to 2FA/TOTP
   - Privacy promise

---

## Navigation Flow

### Tab Navigation (none yet — could be added for Settings vs. OTP List)

### Flow Navigation

- **Main Screen**
  - → Add OTP
  - → Settings
  - → Copy OTP
- **Add OTP**
  - → QR Scanner
  - → Manual Entry
  - → Back to Main
- **QR Scanner**
  - → Auto-fill Add OTP → Save → Main
- **Settings**
  - → Export / About → Back

---
