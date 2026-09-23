#!/data/data/com.termux/files/usr/bin/bash
# ================================================================
#  ██████╗██╗   ██╗██████╗ ███████╗██████╗
# ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗
# ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
# ██║     ██║   ██║██╔══██╗██╔══╝  ██╔══██╗
# ╚██████╗╚██████╔╝██║  ██║███████╗██║  ██║
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#  SCAMSCAN PRO v2.0 — Chitral Cyber Squad Edition
#  Professional Passive Reconnaissance & Evidence Tool
#
#  Organization : Chitral Cyber Squad
#  Admin        : ZIA AKBAR
#  Division     : Chitral Fiberz Kott
#  License      : Ethical / Educational Use Only
#  Copyright    : © 2026 Chitral Cyber Squad
# ================================================================

set -u

# ─────────── CONFIG ───────────
VERSION="2.0 PRO"
ORG="Chitral Cyber Squad"
ADMIN="ZIA AKBAR"
DIVISION="Chitral Fiberz Kott"
CONTACT="admin@chitralcybersquad.pk"
INVESTIGATOR="${ADMIN}"
TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# ─────────── COLORS ───────────
G='\033[0;32m'; R='\033[0;31m'; Y='\033[1;33m'
B='\033[0;34m'; C='\033[0;36m'; M='\033[0;35m'; N='\033[0m'

# ─────────── USAGE ───────────
if [ $# -lt 1 ]; then
  echo -e "${Y}Usage:${N} bash scamscan.sh <domain> [output_dir]"
  echo -e "${Y}Example:${N} bash scamscan.sh suspicious-site.com"
  exit 1
fi

TARGET="$1"
TARGET="${TARGET#http://}"
TARGET="${TARGET#https://}"
TARGET="${TARGET%%/*}"

OUTDIR="${2:-$HOME/ChitralCyberSquad/scamscan/reports/${TARGET}_${TIMESTAMP}}"
mkdir -p "$OUTDIR/raw/js"

REPORT="$OUTDIR/EVIDENCE_REPORT.txt"
ABUSE="$OUTDIR/ABUSE_TEMPLATES.txt"
SUMMARY="$OUTDIR/EXECUTIVE_SUMMARY.txt"

# ─────────── BANNER ───────────
clear
echo -e "${M}"
cat <<'BANNER'
   ██████╗██╗   ██╗██████╗ ███████╗██████╗
  ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗
  ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
  ██║     ██║   ██║██╔══██╗██╔══╝  ██╔══██╗
  ╚██████╗╚██████╔╝██║  ██║███████╗██║  ██║
   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
BANNER
echo -e "${N}"
echo -e "${C}              C H I T R A L   C Y B E R   S Q U A D${N}"
echo -e "${Y}          ─────────────────────────────────────────────${N}"
echo -e "${G}          SCAMSCAN PRO v${VERSION}${N}"
echo -e "${Y}          ─────────────────────────────────────────────${N}"
echo ""
echo -e "  ${C}Organization :${N} $ORG"
echo -e "  ${C}Admin        :${N} $ADMIN"
echo -e "  ${C}Division     :${N} $DIVISION"
echo -e "  ${C}Contact      :${N} $CONTACT"
echo ""
echo -e "  ${C}Target       :${N} ${R}$TARGET${N}"
echo -e "  ${C}Date         :${N} $TODAY"
echo -e "  ${C}Report ID    :${N} CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')"
echo ""
echo -e "${Y}          ─────────────────────────────────────────────${N}"
echo -e "${G}          [ LEGAL USE ONLY — PASSIVE RECONNAISSANCE ]${N}"
echo -e "${Y}          ─────────────────────────────────────────────${N}"
echo ""

sleep 1

# ─────────── LOGGING ───────────
log()  { echo -e "${G}[✓]${N} $1"; }
warn() { echo -e "${Y}[!]${N} $1"; }
info() { echo -e "${C}[i]${N} $1"; }
sec()  { echo -e "\n${M}═══ $1 ═══${N}"; }

# ================================================================
# SECTION 1: WHOIS
# ================================================================
sec "1. WHOIS — DOMAIN REGISTRATION"
whois "$TARGET" > "$OUTDIR/raw/whois.txt" 2>&1
REG_DATE=$(grep -iE "Creation Date|Registered on|created:" "$OUTDIR/raw/whois.txt" | head -1)
REGISTRAR=$(grep -iE "Registrar:" "$OUTDIR/raw/whois.txt" | head -1)
EXPIRY=$(grep -iE "Registry Expiry|Expiry Date|expires:" "$OUTDIR/raw/whois.txt" | head -1)
echo "  $REG_DATE"
echo "  $REGISTRAR"
echo "  $EXPIRY"
log "WHOIS data captured"

# ================================================================
# SECTION 2: DNS
# ================================================================
sec "2. DNS RECORDS"
dig "$TARGET" A +short > "$OUTDIR/raw/dns_a.txt" 2>&1
dig "$TARGET" MX +short > "$OUTDIR/raw/dns_mx.txt" 2>&1
dig "$TARGET" TXT +short > "$OUTDIR/raw/dns_txt.txt" 2>&1
dig "$TARGET" NS +short > "$OUTDIR/raw/dns_ns.txt" 2>&1
echo "  A  : $(cat $OUTDIR/raw/dns_a.txt | tr '\n' ' ')"
echo "  MX : $(cat $OUTDIR/raw/dns_mx.txt | tr '\n' ' ')"
echo "  NS : $(cat $OUTDIR/raw/dns_ns.txt | tr '\n' ' ')"
log "DNS records captured"

# ================================================================
# SECTION 3: HTTP HEADERS
# ================================================================
sec "3. HTTP HEADERS"
curl -sIL "https://$TARGET" -A "ChitralCyberSquad-Scanner/2.0" \
  > "$OUTDIR/raw/headers.txt" 2>&1
SERVER=$(grep -i "^server:" "$OUTDIR/raw/headers.txt" | head -1)
LOCATION=$(grep -i "^location:" "$OUTDIR/raw/headers.txt" | head -1)
echo "  $SERVER"
echo "  $LOCATION"
grep -iE "x-vercel|x-powered|cf-ray|set-cookie|x-frame" "$OUTDIR/raw/headers.txt" | head -5 | sed 's/^/  /'
log "Headers captured"

# ================================================================
# SECTION 4: SSL CERTIFICATE
# ================================================================
sec "4. SSL CERTIFICATE"
echo | openssl s_client -connect "$TARGET:443" -servername "$TARGET" 2>/dev/null \
  | openssl x509 -noout -issuer -subject -dates 2>/dev/null \
  > "$OUTDIR/raw/ssl.txt"
cat "$OUTDIR/raw/ssl.txt" | sed 's/^/  /'
log "SSL captured"

# ================================================================
# SECTION 5: HOMEPAGE
# ================================================================
sec "5. HOMEPAGE FETCH"
curl -sL "https://$TARGET" -A "ChitralCyberSquad-Scanner/2.0" \
  -o "$OUTDIR/raw/homepage.html" 2>&1
HOMEPAGE_SIZE=$(wc -c < "$OUTDIR/raw/homepage.html")
echo "  Size: $HOMEPAGE_SIZE bytes"
[ "$HOMEPAGE_SIZE" -lt 100 ] && warn "Suspiciously small — likely redirect stub"
log "Homepage captured"

# ================================================================
# SECTION 6: JS BUNDLES
# ================================================================
sec "6. JAVASCRIPT BUNDLE EXTRACTION"
grep -oE '/_next/static/chunks/[a-zA-Z0-9._/-]+\.js' \
  "$OUTDIR/raw/homepage.html" 2>/dev/null | sort -u > "$OUTDIR/raw/js_list.txt"
JS_COUNT=$(wc -l < "$OUTDIR/raw/js_list.txt")
echo "  Found $JS_COUNT JS bundles"

while read -r js; do
  [ -z "$js" ] && continue
  fname=$(echo "$js" | tr '/' '_')
  curl -s "https://$TARGET$js" -o "$OUTDIR/raw/js/$fname" 2>/dev/null
done < "$OUTDIR/raw/js_list.txt"
log "JS bundles saved"

# ================================================================
# SECTION 7: API ENDPOINTS
# ================================================================
sec "7. API ENDPOINT DISCOVERY"
grep -rohE '/api/[a-zA-Z0-9/_?=&-]+' "$OUTDIR/raw/js/" 2>/dev/null \
  | sort -u > "$OUTDIR/raw/api_endpoints.txt"
grep -rohE 'https?://[a-zA-Z0-9.-]+\.(vercel\.app|workers\.dev|netlify\.app|github\.io|firebaseapp\.com|supabase\.co|railway\.app|onrender\.com)' \
  "$OUTDIR/raw/js/" 2>/dev/null | sort -u > "$OUTDIR/raw/backend_urls.txt"
echo "  API Endpoints:"; cat "$OUTDIR/raw/api_endpoints.txt" | head -10 | sed 's/^/    /'
echo "  Backend URLs:"; cat "$OUTDIR/raw/backend_urls.txt" | head -10 | sed 's/^/    /'
log "API scan complete"

# ================================================================
# SECTION 8: AUTH STACK
# ================================================================
sec "8. AUTHENTICATION & DATA COLLECTION"
{
  grep -rohE 'next-auth|nextauth|firebase|supabase|auth0|clerk|okta' "$OUTDIR/raw/js/" 2>/dev/null | sort -u
  grep -rohE '"email"|"password"|"session"|"jwt"|"bearer"|"2FA"' "$OUTDIR/raw/js/" 2>/dev/null | sort -u
  grep -rohE 'localStorage\.[a-zA-Z]+|sessionStorage\.[a-zA-Z]+|document\.cookie' "$OUTDIR/raw/js/" 2>/dev/null | sort -u
} > "$OUTDIR/raw/auth_stack.txt"
cat "$OUTDIR/raw/auth_stack.txt" | head -20 | sed 's/^/  /'
log "Auth stack captured"

# ================================================================
# SECTION 9: TRACKERS
# ================================================================
sec "9. TRACKING & ANALYTICS TOOLS"
grep -rohE 'google-analytics|gtag|googletagmanager|mixpanel|amplitude|segment|sentry|posthog|hotjar|clarity|vercel-scripts' \
  "$OUTDIR/raw/js/" "$OUTDIR/raw/homepage.html" 2>/dev/null \
  | sort -u > "$OUTDIR/raw/trackers.txt"
cat "$OUTDIR/raw/trackers.txt" | sed 's/^/  /'
log "Trackers captured"

# ================================================================
# SECTION 10: SOCIAL LINKS
# ================================================================
sec "10. SOCIAL & EXTERNAL LINKS"
grep -ohE 'https?://(www\.)?(x\.com|twitter\.com|instagram\.com|facebook\.com|reddit\.com|threads\.com|youtube\.com|t\.me)[a-zA-Z0-9._/?#=&-]+' \
  "$OUTDIR/raw/homepage.html" "$OUTDIR/raw/js/"* 2>/dev/null \
  | sort -u > "$OUTDIR/raw/social_links.txt"
cat "$OUTDIR/raw/social_links.txt" | sed 's/^/  /'
log "Social links captured"

# ================================================================
# SECTION 11: YOUTUBE METADATA
# ================================================================
sec "11. YOUTUBE VIDEO ANALYSIS"
grep -ohE 'youtube\.com/embed/[a-zA-Z0-9_-]+' "$OUTDIR/raw/homepage.html" 2>/dev/null \
  | sed 's|.*/||' | sort -u > "$OUTDIR/raw/yt_ids.txt"

: > "$OUTDIR/raw/yt_meta.txt"
while read -r vid; do
  [ -z "$vid" ] && continue
  echo "--- Video ID: $vid ---" >> "$OUTDIR/raw/yt_meta.txt"
  curl -s "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$vid&format=json" \
    >> "$OUTDIR/raw/yt_meta.txt" 2>&1
  echo "" >> "$OUTDIR/raw/yt_meta.txt"
done < "$OUTDIR/raw/yt_ids.txt"
cat "$OUTDIR/raw/yt_meta.txt" | head -20 | sed 's/^/  /'
log "YouTube metadata captured"

# ================================================================
# SECTION 12: WAYBACK MACHINE
# ================================================================
sec "12. WAYBACK MACHINE HISTORY"
curl -s "http://web.archive.org/cdx/search/cdx?url=$TARGET&output=json&limit=20" \
  > "$OUTDIR/raw/wayback_history.txt"
curl -s "http://archive.org/wayback/available?url=$TARGET" \
  > "$OUTDIR/raw/wayback_available.txt"
head -5 "$OUTDIR/raw/wayback_available.txt" | sed 's/^/  /'
log "Wayback history captured"

# ================================================================
# SECTION 13: ROBOTS & SITEMAP
# ================================================================
sec "13. ROBOTS.TXT & SITEMAP"
curl -s "https://$TARGET/robots.txt" -o "$OUTDIR/raw/robots.txt" 2>&1
curl -s "https://$TARGET/sitemap.xml" -o "$OUTDIR/raw/sitemap.xml" 2>&1
echo "  robots.txt : $(wc -c < $OUTDIR/raw/robots.txt) bytes"
echo "  sitemap.xml: $(wc -c < $OUTDIR/raw/sitemap.xml) bytes"
log "robots/sitemap captured"

# ================================================================
# SECTION 14: STRUCTURED DATA
# ================================================================
sec "14. STRUCTURED DATA (FAKE REVIEW DETECTION)"
grep -oE '<script type="application/ld\+json">[^<]+' "$OUTDIR/raw/homepage.html" \
  > "$OUTDIR/raw/structured_data.txt" 2>/dev/null
cat "$OUTDIR/raw/structured_data.txt" | head -5 | sed 's/^/  /'
log "Structured data captured"

# ================================================================
# SECTION 15: HOSTING INFO
# ================================================================
sec "15. HOSTING & GEOLOCATION"
FIRST_IP=$(dig +short "$TARGET" | head -1)
HOST_INFO=$(curl -s "https://ipinfo.io/$FIRST_IP/json" 2>/dev/null)
echo "$HOST_INFO" | jq -r '"  Org    : \(.org)\n  Country: \(.country)\n  City   : \(.city)\n  IP     : \(.ip)"' 2>/dev/null
echo "$HOST_INFO" > "$OUTDIR/raw/host_info.json"
log "Hosting info captured"

# ================================================================
# GENERATE PROFESSIONAL EVIDENCE REPORT
# ================================================================
sec "GENERATING PROFESSIONAL EVIDENCE REPORT"

cat > "$REPORT" <<EOF
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║               C H I T R A L   C Y B E R   S Q U A D          ║
║                                                              ║
║              CYBERSECURITY EVIDENCE REPORT                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

┌──────────────────────────────────────────────────────────────┐
│ REPORT IDENTIFICATION                                        │
├──────────────────────────────────────────────────────────────┤
│ Report ID     : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')
│ Date          : $TODAY
│ Time          : $(date +%H:%M:%S)
│ Analyst       : $ADMIN
│ Organization  : $ORG
│ Division      : $DIVISION
│ Contact       : $CONTACT
│ Tool Version  : SCAMSCAN PRO v$VERSION
│ Target Domain : $TARGET
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ EXECUTIVE SUMMARY                                            │
├──────────────────────────────────────────────────────────────┤
│ This report presents a comprehensive passive reconnaissance  │
│ analysis of the target domain conducted in accordance with   │
│ ethical cybersecurity practices. All data was collected from │
│ publicly accessible sources. No unauthorized access,         │
│ exploitation, or intrusion was performed.                    │
│                                                              │
│ Purpose: Evidence collection for abuse reporting and         │
│ community protection as part of $DIVISION operations.        │
└──────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════
  SECTION 1: DOMAIN REGISTRATION (WHOIS)
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/whois.txt | head -40)

═══════════════════════════════════════════════════════════════
  SECTION 2: DNS RECORDS
═══════════════════════════════════════════════════════════════
A Records  : $(cat $OUTDIR/raw/dns_a.txt | tr '\n' ' ')
MX Records : $(cat $OUTDIR/raw/dns_mx.txt | tr '\n' ' ')
NS Records : $(cat $OUTDIR/raw/dns_ns.txt | tr '\n' ' ')

═══════════════════════════════════════════════════════════════
  SECTION 3: HTTP HEADERS
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/headers.txt)

═══════════════════════════════════════════════════════════════
  SECTION 4: SSL CERTIFICATE
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/ssl.txt)

═══════════════════════════════════════════════════════════════
  SECTION 5: HOMEPAGE ANALYSIS
═══════════════════════════════════════════════════════════════
Homepage Size : $HOMEPAGE_SIZE bytes
JS Bundles    : $JS_COUNT files

═══════════════════════════════════════════════════════════════
  SECTION 6: API ENDPOINTS DETECTED
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/api_endpoints.txt)

═══════════════════════════════════════════════════════════════
  SECTION 7: BACKEND & THIRD-PARTY URLS
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/backend_urls.txt)

═══════════════════════════════════════════════════════════════
  SECTION 8: AUTHENTICATION STACK
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/auth_stack.txt)

═══════════════════════════════════════════════════════════════
  SECTION 9: TRACKING TOOLS
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/trackers.txt)

═══════════════════════════════════════════════════════════════
  SECTION 10: SOCIAL MEDIA LINKS
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/social_links.txt)

═══════════════════════════════════════════════════════════════
  SECTION 11: YOUTUBE VIDEO METADATA
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/yt_meta.txt)

═══════════════════════════════════════════════════════════════
  SECTION 12: WAYBACK MACHINE HISTORY
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/wayback_history.txt | head -30)

═══════════════════════════════════════════════════════════════
  SECTION 13: ROBOTS.TXT & SITEMAP
═══════════════════════════════════════════════════════════════
robots.txt  : $(wc -c < $OUTDIR/raw/robots.txt) bytes
sitemap.xml : $(wc -c < $OUTDIR/raw/sitemap.xml) bytes

═══════════════════════════════════════════════════════════════
  SECTION 14: STRUCTURED DATA (SEO / REVIEW SCHEMA)
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/structured_data.txt | head -20)

═══════════════════════════════════════════════════════════════
  SECTION 15: HOSTING & GEOLOCATION
═══════════════════════════════════════════════════════════════
$(cat $OUTDIR/raw/host_info.json)

╔══════════════════════════════════════════════════════════════╗
║                    END OF EVIDENCE REPORT                    ║
╠══════════════════════════════════════════════════════════════╣
║ Report Generated by : SCAMSCAN PRO v$VERSION                    ║
║ Organization        : $ORG                     ║
║ Admin               : $ADMIN                             ║
║ Contact             : $CONTACT           ║
╚══════════════════════════════════════════════════════════════╝
EOF

# ================================================================
# GENERATE EXECUTIVE SUMMARY (1-page)
# ================================================================
cat > "$SUMMARY" <<EOF
╔══════════════════════════════════════════════════════════════╗
║          CHITRAL CYBER SQUAD — EXECUTIVE SUMMARY            ║
╚══════════════════════════════════════════════════════════════╝

Target    : $TARGET
Date      : $TODAY
Analyst   : $ADMIN
Report ID : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')

──────────────────────────────────────────────────────────────
KEY FINDINGS
──────────────────────────────────────────────────────────────

HOSTING
  Provider : $(grep -i "^server:" $OUTDIR/raw/headers.txt | head -1 | cut -d: -f2 | tr -d ' ')
  IP       : $(dig +short $TARGET | head -1)
  Location : $(cat $OUTDIR/raw/host_info.json | jq -r '.city + ", " + .country' 2>/dev/null)

DOMAIN
  $REG_DATE
  $REGISTRAR

AUTHENTICATION
  $(cat $OUTDIR/raw/auth_stack.txt | head -3)

DATA COLLECTION
  $(cat $OUTDIR/raw/trackers.txt | head -3)

SOCIAL PROFILES
  $(cat $OUTDIR/raw/social_links.txt | head -5)

──────────────────────────────────────────────────────────────
RECOMMENDED ACTIONS
──────────────────────────────────────────────────────────────
  1. Report to hosting provider (abuse contact)
  2. Report to domain registrar
  3. Report to Google Safe Browsing
  4. Notify $DIVISION subscribers
  5. Escalate to FIA Cybercrime (if in Pakistan)

──────────────────────────────────────────────────────────────
Generated by SCAMSCAN PRO v$VERSION — $ORG
EOF

# ================================================================
# GENERATE ABUSE EMAIL TEMPLATES
# ================================================================
cat > "$ABUSE" <<EOF
╔══════════════════════════════════════════════════════════════╗
║          CHITRAL CYBER SQUAD — ABUSE EMAIL TEMPLATES        ║
║          Target: $TARGET
║          Report ID: CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')
╚══════════════════════════════════════════════════════════════╝

──────────────────────────────────────────────────────────────
TEMPLATE 1: HOSTING PROVIDER (HIGHEST PRIORITY)
──────────────────────────────────────────────────────────────
TO      : abuse@vercel.com  [adjust based on hosting]
SUBJECT : [ABUSE-REPORT-CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')] Malicious Content on $TARGET

Dear Abuse Team,

I am $ADMIN, Admin of $ORG ($DIVISION), a cybersecurity
initiative dedicated to protecting internet users in the
Chitral region of Pakistan.

I am reporting a Terms of Service violation hosted on your
infrastructure.

TARGET      : $TARGET
REPORT ID   : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')
DATE        : $TODAY
HOSTING     : $(grep -i "^server:" $OUTDIR/raw/headers.txt | head -1)

VIOLATION SUMMARY:
This website has been identified through passive
reconnaissance as distributing malicious software and
engaging in deceptive practices.

TECHNICAL EVIDENCE ATTACHED:
  - WHOIS registration data
  - DNS records
  - HTTP headers analysis
  - SSL certificate details
  - JavaScript bundle analysis
  - Authentication stack fingerprint
  - Tracker/analytics detection

All evidence was collected using publicly available
information only. No unauthorized access was performed.

I respectfully request immediate review and suspension
under your Acceptable Use Policy.

Regards,
$ADMIN
Admin — $ORG
$DIVISION
$CONTACT

──────────────────────────────────────────────────────────────
TEMPLATE 2: DOMAIN REGISTRAR
──────────────────────────────────────────────────────────────
TO      : [registrar abuse email — see WHOIS section]
SUBJECT : [ABUSE-CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')] Malicious Domain $TARGET

Dear Registrar Abuse Team,

I am reporting a domain registered through your service
that is being used for malicious purposes.

DOMAIN      : $TARGET
REGISTRAR   : $(grep -i "Registrar:" $OUTDIR/raw/whois.txt | head -1)
REPORT ID   : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')

Full technical evidence attached.

Regards,
$ADMIN — $ORG

──────────────────────────────────────────────────────────────
TEMPLATE 3: GOOGLE SAFE BROWSING
──────────────────────────────────────────────────────────────
URL  : https://safebrowsing.google.com/safebrowsing/report_phish/
Form : Fill and attach evidence report

URL        : https://$TARGET
CATEGORY   : Malware / Stalkerware / Phishing
REPORT ID  : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')

──────────────────────────────────────────────────────────────
TEMPLATE 4: SOCIAL PLATFORMS (X, Instagram, Reddit, Threads)
──────────────────────────────────────────────────────────────
Report the following accounts as promoting malware:

$(cat $OUTDIR/raw/social_links.txt)

Reason: Promoting illegal surveillance tools / malware
Report ID: CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')

──────────────────────────────────────────────────────────────
TEMPLATE 5: FIA CYBERCRIME WING (PAKISTAN)
──────────────────────────────────────────────────────────────
Portal : https://complaint.fia.gov.pk
Subject: Cybercrime Report — Malicious Domain $TARGET

Respected Sir/Madam,

I am $ADMIN, Admin of $ORG ($DIVISION). I am
reporting a malicious website operating against the
public interest.

DOMAIN     : $TARGET
REPORT ID  : CCS-$(echo $TARGET | md5sum | cut -c1-8 | tr 'a-z' 'A-Z')
DATE       : $TODAY
EVIDENCE   : Attached (comprehensive technical report)

Regards,
$ADMIN
$ORG — $DIVISION
$CONTACT

╔══════════════════════════════════════════════════════════════╗
║  Generated by SCAMSCAN PRO v$VERSION — $ORG      ║
╚══════════════════════════════════════════════════════════════╝
EOF

# ================================================================
# FINAL SUMMARY
# ================================================================
echo ""
echo -e "${M}═══════════════════════════════════════════════════════${N}"
echo -e "${G}   ✓ SCAN COMPLETE — $ORG${N}"
echo -e "${M}═══════════════════════════════════════════════════════${N}"
echo ""
echo -e "  ${C}📄 Evidence Report   :${N} $REPORT"
echo -e "  ${C}📋 Executive Summary :${N} $SUMMARY"
echo -e "  ${C}📧 Abuse Templates   :${N} $ABUSE"
echo -e "  ${C}📁 Raw Data          :${N} $OUTDIR/raw/"
echo ""
echo -e "${Y}  Next Steps:${N}"
echo "    1. View report : cat $REPORT"
echo "    2. View summary: cat $SUMMARY"
echo "    3. Send abuse  : cat $ABUSE"
echo "    4. Screenshot all sections for records"
echo ""
echo -e "${G}  Stay ethical. Stay legal. Protect the community.${N}"
echo -e "${C}  — $ADMIN, $ORG${N}"
echo ""
