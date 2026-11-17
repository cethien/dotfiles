{pkgs}: let
  nvme = "${pkgs.nvme-cli}/bin/nvme";
in
  pkgs.writeShellScriptBin "check-nvme-wearout"
  # bash
  ''
    set -euo pipefail

    if [ "$EUID" -ne 0 ]; then
       echo "This script must be run with sudo!"
       exit 1
    fi

    ${nvme} smart-log /dev/nvme0 | grep -E "percentage_used|spare|warning"
  ''
