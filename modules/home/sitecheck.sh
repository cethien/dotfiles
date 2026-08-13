#!/usr/bin/env bash
set -euo pipefail

# @describe Fast domain status check (RDAP/WHOIS, SSL/TLS, DNS)
# @meta require-tools jq,whois,openssl,doggo,curl,gum
# @meta show-help-with gum format

# @cmd
# @arg target! Target domain to check
main() {
	local target="$argc_target"

	echo ""

	local rdap_json
	rdap_json=$(curl -sL -m 3 "https://rdap.org/domain/$target" 2>/dev/null || true)

	if echo "$rdap_json" | grep -q '"objectClassName"'; then
		_check_rdap "$target" "$rdap_json"
	else
		_check_whois "$target"
	fi

	echo ""
	_check_ssl "$target"
	echo ""
	_check_dns "$target"
}

_header() {
	local text="$1"
	local color="${2:-212}"
	gum style --bold --foreground "$color" ">> $text"
}

_check_rdap() {
	local target="$1"
	local rdap_json="$2"

	_header "RDAP" 39

	local registrar created expires
	registrar=$(echo "$rdap_json" | jq -r '.entities[]? | select(.roles[]? == "registrar") | .vcardArray[1][]? | select(.[0] == "fn") | .[3]' 2>/dev/null | head -n 1)
	created=$(echo "$rdap_json" | jq -r '.events[]? | select(.action == "registration") | .eventDate' 2>/dev/null)
	expires=$(echo "$rdap_json" | jq -r '.events[]? | select(.action == "expiration") | .eventDate' 2>/dev/null)

	[[ -n "$registrar" && "$registrar" != "null" ]] && echo -e "\033[33mRegistrar:\033[0m $registrar"
	[[ -n "$created" && "$created" != "null" ]] && echo -e "\033[33mCreated:\033[0m   $created"
	[[ -n "$expires" && "$expires" != "null" ]] && echo -e "\033[33mExpires:\033[0m   $expires"
}

_check_whois() {
	local target="$1"

	_header "WHOIS" 39

	local whois_raw parsed
	whois_raw=$(whois "$target" 2>/dev/null || true)
	parsed=$(echo "$whois_raw" | grep -iE '^(domain|registrar|created|creation date|expir|updated date|nserver|status):' | head -n 8 || true)

	if [[ -n "$parsed" ]]; then
		echo "$parsed"
	else
		_log_warn "no readable WHOIS data found"
	fi
}

_check_ssl() {
	local target="$1"
	local ssl_out

	ssl_out=$(timeout 3 openssl s_client -connect "$target":443 -servername "$target" </dev/null 2>&1 || true)

	if echo "$ssl_out" | grep -q "BEGIN CERTIFICATE"; then
		if echo "$ssl_out" | grep -q "Verify return code: 0 (ok)"; then
			_header "SSL/TLS Valid" 82
		else
			_header "SSL/TLS Invalid" 196
		fi
		echo "$ssl_out" | openssl x509 -noout -issuer -dates 2>/dev/null || true
	else
		_header "SSL/TLS Unavailable" 208
		_log_warn "closed / timeout / no ssl"
	fi
}

_check_dns() {
	local target="$1"
	_header "DNS" 33

	local local_ns
	local_ns=$(grep -m1 '^nameserver' /etc/resolv.conf | awk '{print $2}' || true)

	doggo "$target" A AAAA MX NS TXT CNAME "@${local_ns:-1.1.1.1}"
}

_log_warn() {
	gum log --time TimeOnly --level warn "$*"
}

eval "$(argc --argc-eval "$0" "$@")"
