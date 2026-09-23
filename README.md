# 🛡️ SCAMSCAN PRO v2.0

**Chitral Cyber Squad Edition**

> ⚠️ **LEGAL NOTICE:** This tool is for **legal, ethical, and
> defensive cybersecurity use ONLY**. By using it, you agree to our
> [Terms of Use](TERMS.md), [Privacy Policy](PRIVACY.md), and
> [Disclaimer](DISCLAIMER.md). Misuse is strictly prohibited and
> may be prosecuted under PECA 2016 (Pakistan) and international law.

---

## 📖 Overview

SCAMSCAN PRO is a legal, ethical, passive reconnaissance tool designed for:

- Identifying stalkerware and malware distribution sites
- Collecting verifiable evidence for abuse reports
- Generating professional-grade cybersecurity documentation
- Community protection in the Chitral region

**All operations use only publicly available data.**

---

## 🚀 Installation

```bash
pkg update && pkg upgrade -y
pkg install -y curl whois dnsutils openssl-tool jq git nano
git clone https://github.com/ChitralCyberSquad/scamscan-pro.git
cd scamscan-pro
cp config/config.env.example config/config.env
nano config/config.env
chmod +x scamscan.sh
```

---

## 🎯 Usage

```bash
bash scamscan.sh <domain>
```

Example:

```bash
bash scamscan.sh suspicious-site.com
```

Outputs:
- `EVIDENCE_REPORT.txt` — Full technical report
- `EXECUTIVE_SUMMARY.txt` — 1-page summary
- `ABUSE_TEMPLATES.txt` — Pre-filled abuse emails
- `raw/` — All raw scan data

---

## 🏢 Organization

**Chitral Cyber Squad**
- Admin: ZIA AKBAR
- Division: Chitral Fiberz Kott
- Contact: chitralcybersquad@gmail.com
- GitHub: https://github.com/ChitralCyberSquad

---

## ⚖️ Legal

- [Terms of Use](TERMS.md)
- [Privacy Policy](PRIVACY.md)
- [Disclaimer](DISCLAIMER.md)
- [Security Policy](.github/SECURITY.md)

---

## 📜 License

Ethical Use License — see [LICENSE](LICENSE).

---

**© 2026 Chitral Cyber Squad — All Rights Reserved**
