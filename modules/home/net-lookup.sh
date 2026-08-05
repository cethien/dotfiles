#!/usr/bin/env bash

header() {
	local text="$1"
	local color="$2"
	local icon="${3:-}"

	[ -n "$icon" ] && icon=" $icon"
	echo -e "\033[1;${color}m>> ${text}${icon}\033[0m"
}

get_target() {
	local target="$1"
	if [ -z "$target" ]; then
		read -r -e -p "lookup domain: " target
	fi

	[ -z "$target" ] && {
		echo "no target provided" >&2
		exit 1
	}
	echo "$target"
}

check_rdap() {
	local target="$1"
	local rdap_json="$2"

	header "RDAP" "36"

	local registrar created expires
	registrar=$(echo "$rdap_json" | jq -r '.entities[]? | select(.roles[]? == "registrar") | .vcardArray[1][]? | select(.[0] == "fn") | .[3]' 2>/dev/null | head -n 1)
	created=$(echo "$rdap_json" | jq -r '.events[]? | select(.action == "registration") | .eventDate' 2>/dev/null)
	expires=$(echo "$rdap_json" | jq -r '.events[]? | select(.action == "expiration") | .eventDate' 2>/dev/null)

	[[ -n "$registrar" && "$registrar" != "null" ]] && echo -e "\033[33mRegistrar:\033[0m $registrar"
	[[ -n "$created" && "$created" != "null" ]] && echo -e "\033[33mCreated:\033[0m   $created"
	[[ -n "$expires" && "$expires" != "null" ]] && echo -e "\033[33mExpires:\033[0m   $expires"
}

check_whois() {
	local target="$1"

	header "WHOIS" "36"

	local whois_raw parsed
	whois_raw=$(whois "$target" 2>/dev/null)
	parsed=$(echo "$whois_raw" | grep -iE '^(domain|registrar|created|creation date|expir|updated date|nserver|status):' | head -n 8)

	if [ -n "$parsed" ]; then
		echo "$parsed"
	else
		echo "no readable data found"
	fi
}

check_ssl() {
	local target="$1"
	local ssl_out icon=""

	ssl_out=$(timeout 3 openssl s_client -connect "$target":443 -servername "$target" </dev/null 2>&1)

	if echo "$ssl_out" | grep -q "BEGIN CERTIFICATE"; then
		icon="❌"
		echo "$ssl_out" | grep -q "Verify return code: 0 (ok)" && icon="✅"
	fi

	header "SSL/TLS" "35" "$icon"

	if [ -n "$icon" ]; then
		echo "$ssl_out" | openssl x509 -noout -issuer -dates 2>/dev/null
	else
		echo "closed / timeout / no ssl"
	fi
}

check_dns() {
	local target="$1"
	header "DNS" "34"
	local local_ns
	local_ns=$(grep -m1 '^nameserver' /etc/resolv.conf | awk '{print $2}')

	doggo "$target" A AAAA MX NS TXT CNAME "@${local_ns:-1.1.1.1}"
}

# --- Execution ---
TARGET=$(get_target "${1:-}")

echo "lookup domain: $TARGET"
echo ""

RDAP_JSON=$(curl -sL -m 3 "https://rdap.org/domain/$TARGET" 2>/dev/null)

if echo "$RDAP_JSON" | grep -q '"objectClassName"'; then
	check_rdap "$TARGET" "$RDAP_JSON"
else
	check_whois "$TARGET"
fi

echo ""
check_ssl "$TARGET"
echo ""
check_dns "$TARGET"
