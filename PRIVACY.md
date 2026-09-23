# 🔒 Privacy Policy — SCAMSCAN PRO

**Effective Date:** 23 September 2026
**Last Updated:** 23 September 2026
**Version:** 2.0
**Maintained By:** Chitral Cyber Squad
**Admin:** ZIA AKBAR
**Contact:** chitralcybersquad@gmail.com

---

## 1. Overview

SCAMSCAN PRO is a **passive reconnaissance and evidence-collection tool**
developed by **Chitral Cyber Squad** for cybersecurity education,
abuse reporting, and community protection. This Privacy Policy
explains what data the tool **does** and **does not** collect, how
it is handled, and your rights as a user.

---

## 2. What This Tool Collects

SCAMSCAN PRO operates **entirely on your local device (Termux)**.
It does **NOT** transmit any data to Chitral Cyber Squad, its admin,
or any third party.

### 2.1 Data Collected Locally (On Your Device Only)

When you run the tool against a target domain, it saves the
following **locally** to your Termux filesystem:

- WHOIS registration data
- DNS records (A, MX, TXT, NS)
- HTTP response headers
- SSL certificate details
- Downloaded HTML and JavaScript bundles
- Extracted API endpoints and third-party URLs
- Detected trackers and authentication frameworks
- Social media links found on the target
- YouTube video metadata (via public oEmbed API)
- Wayback Machine history (via public archive API)
- Hosting/geolocation info (via ipinfo.io public API)

**This data never leaves your device** except when you choose to
share it (e.g., attaching a report to an abuse complaint).

### 2.2 Data Collected by Third-Party APIs

The tool makes **read-only GET requests** to publicly available
services. These services may log your IP address as part of their
normal operation (as any website does when you visit it):

| Service | Purpose | Their Privacy Policy |
|---|---|---|
| WHOIS servers | Domain registration lookup | Varies by registry |
| DNS resolvers | DNS queries | Varies by resolver |
| ipinfo.io | Hosting geolocation | https://ipinfo.io/privacy-policy |
| YouTube oEmbed | Video metadata | https://policies.google.com/privacy |
| Archive.org | Wayback Machine history | https://archive.org/about/terms.php |

Chitral Cyber Squad has **no control** over these third parties and
**does not receive** any data from them.

---

## 3. What This Tool Does NOT Collect

SCAMSCAN PRO **never** collects, stores, or transmits:

- ❌ Your personal information (name, email, phone)
- ❌ Your target's private data (no login, no intrusion)
- ❌ Credentials, passwords, or authentication tokens
- ❌ Any information about the operator running the tool
- ❌ Analytics, telemetry, or usage statistics
- ❌ Crash reports or error logs sent to us
- ❌ IP addresses of the operator (unless a third-party API logs it)

---

## 4. Local Data Storage

All scan output is stored **locally** under:
