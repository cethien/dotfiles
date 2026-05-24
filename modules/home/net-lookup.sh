#!/usr/bin/env bash
if [ -n "$1" ]; then
  TARGET="$1"
else
  read -p "target domain: " TARGET
fi

if [ -z "$TARGET" ]; then
  echo "No target provided. Aborting."
  exit 1
fi

clear
echo -e "\033[1;33m====================================================\033[0m"
echo -e "\033[1;33m SCANNING TARGET: $TARGET\033[0m"
echo -e "\033[1;33m====================================================\033[0m\n"

echo -e "\033[1;36m[+] WHOIS REGISTRY SUMMARY\033[0m"
whois "$TARGET" | grep -E -i '^(domain name|registrar:|whois server:|creation date|expiry date|updated date|name server:|status:)' | sed 's/^/  /' || echo "  -> WHOIS data unavailable or rate-limited."
echo ""

echo -e "\033[1;35m[+] SSL/TLS CERTIFICATE\033[0m"
timeout 3 openssl s_client -connect "$TARGET":443 -servername "$TARGET" </dev/null 2>/dev/null |
  openssl x509 -noout -issuer -subject -dates 2>/dev/null || echo "  -> Port 443 closed or connection timeout."
echo ""

echo -e "\033[1;34m[+] DNS RECORDS (doggo)\033[0m"
doggo "$TARGET" A AAAA MX NS TXT CNAME --color
echo ""
