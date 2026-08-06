#!/usr/bin/env bash

ACTIVE_DEV=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+')
[ -z "$ACTIVE_DEV" ] && exit 0

ACTIVE_WIFI=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2)
if [ -n "$ACTIVE_WIFI" ] && command -v qrencode >/dev/null; then
	PASS=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ACTIVE_WIFI" 2>/dev/null)
	if [ -n "$PASS" ]; then
		qrencode -m 1 -t UTF8i "WIFI:S:$ACTIVE_WIFI;T:WPA;P:$PASS;;"
		echo ""
	fi
fi

SHOW_OUT=$(nmcli dev show "$ACTIVE_DEV" 2>/dev/null)

DOMAIN=$(echo "$SHOW_OUT" | grep 'IP4.DOMAIN' | awk '{print $2}')
IPV4=$(echo "$SHOW_OUT" | grep 'IP4.ADDRESS' | awk '{print $2}')
IPV6=$(echo "$SHOW_OUT" | grep 'IP6.ADDRESS' | awk '{print $2}')
GWV4=$(echo "$SHOW_OUT" | grep 'IP4.GATEWAY' | awk '{print $2}')
GWV6=$(echo "$SHOW_OUT" | grep 'IP6.GATEWAY' | awk '{print $2}')

mapfile -t DNS_LIST < <(echo "$SHOW_OUT" | grep -E '(IP4.DNS|IP6.DNS)' | awk '{print $2}')

IP="${IPV4:-$IPV6}"
GW="${GWV4:-$GWV6}"

[ -n "$DOMAIN" ] && echo -e "\033[1;36mdomain:\033[0m  $DOMAIN"
[ -n "$IP" ] && echo -e "\033[1;33mip:\033[0m      $IP"

if [ -n "$GW" ]; then
	GW_LINK="\e]8;;http://${GW}\e\\${GW}\e]8;;\e\\"
	echo -e "\033[1;35mgateway:\033[0m $GW_LINK"
fi

if [ ${#DNS_LIST[@]} -gt 0 ]; then
	echo -e "\033[1;34mdns:\033[0m     ${DNS_LIST[0]}"
	for ((i = 1; i < ${#DNS_LIST[@]}; i++)); do
		echo "        ${DNS_LIST[$i]}"
	done
fi
