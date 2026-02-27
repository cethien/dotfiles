#!/usr/bin/env bash

config_file="$HOME/.ssh/config"
known_hosts="$HOME/.ssh/known_hosts"
failed_hosts=()
i=0

if [[ ! -f "$config_file" ]]; then
  echo "❌ config not found at $config_file"
  exit 1
fi

while read -r alias target; do
  [[ -z "$target" ]] && continue
  ((i++))

  low_alias=$(echo "$alias" | tr '[:upper:]' '[:lower:]')
  low_target=$(echo "$target" | tr '[:upper:]' '[:lower:]')

  echo -n "🔍 [$i] scanning: $low_alias ($low_target)... "

  temp_key=$(ssh-keyscan -H -T 3 "$target" 2>/dev/null)

  if [[ -n "$temp_key" ]]; then
    echo "$temp_key" >>"$known_hosts"
    echo "done"
  else
    echo "failed"
    failed_hosts+=("$low_alias ($low_target)")
  fi

done < <(awk 'tolower($1) == "host" { alias=$2 } tolower($1) == "hostname" { print alias, $2 }' "$config_file")

echo ""
echo "✅ all hosts processed."

if [[ ${#failed_hosts[@]} -ne 0 ]]; then
  echo ""
  echo "⚠️  failed hosts:"
  for failed in "${failed_hosts[@]}"; do
    echo "   - $failed"
  done
fi
