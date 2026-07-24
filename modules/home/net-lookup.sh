#!/usr/bin/env bash

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
	read -r -e -p "lookup domain: " TARGET
else
	echo "lookup domain: $TARGET"
fi

if [ -z "$TARGET" ]; then
	echo "no target provided"
	exit 1
fi

echo ""

echo -e "\033[1;36m>> whois:\033[0m"
whois "$TARGET" | grep -E -i '^(domain name|registrar:|whois server:|creation date|expiry date|updated date|name server:|status:)' | sed 's/^/  /' || echo "  no data"
echo ""

echo -e "\033[1;35m>> ssl/tls:\033[0m"
timeout 3 openssl s_client -connect "$TARGET":443 -servername "$TARGET" </dev/null 2>/dev/null |
	openssl x509 -noout -issuer -subject -dates 2>/dev/null || echo "  closed / timeout"
echo ""

echo -e "\033[1;34m>> dns:\033[0m"
doggo "$TARGET" A AAAA MX NS TXT CNAME --color
echo ""
