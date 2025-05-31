{pkgs, ...}:
pkgs.writeShellScriptBin "setup-age" ''
  set -euo pipefail

  export DB_PATH="$HOME/.keepass/vault.kdbx"
  export AGE_KEY_PATH="$HOME/.config/sops/age/keys.txt"

  if [ -f "$AGE_KEY_PATH" ]; then
    echo "✅ Age key already exists at $AGE_KEY_PATH"
    exit 0
  fi

  echo "🔐 Prompting for KeePassXC password..."
  read -s -p "Enter KeePassXC DB password: " KEEPASS_PW
  echo

  echo "🔑 Extracting SSH key..."
  TEMP_KEY=$(mktemp)
  echo "$KEEPASS_PW" | ${pkgs.keepassxc}/bin/keepassxc-cli attachment-export \
    "$DB_PATH" "borislaw.sotnikow@gmx.de" "id_ed25519" --stdout > "$TEMP_KEY"

  mkdir -p "$(dirname "$AGE_KEY_PATH")"
  ${pkgs.ssh-to-age}/bin/ssh-to-age -i "$TEMP_KEY" > "$AGE_KEY_PATH"
  chmod 600 "$AGE_KEY_PATH"
  rm -f "$TEMP_KEY"

  echo "✅ Age key saved to $AGE_KEY_PATH"
''
