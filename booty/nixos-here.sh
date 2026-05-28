#!/usr/bin/env bash
set -euo pipefail

FLAKE=""
DISK=""

while [[ $# -gt 0 ]]; do
  case $1 in
  --flake)
    FLAKE="$2"
    shift 2
    ;;
  --disk)
    DISK="$2"
    shift 2
    ;;
  *)
    echo "unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ -z "$FLAKE" || -z "$DISK" ]]; then
  echo "error: both arguments required."
  echo "usage: $0 --flake <flake#config> --disk /dev/disk/by-id/xyz"
  exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "error: must be run with sudo."
  exit 1
fi

echo "==> preparing disko..."
export TARGET_DISK="$DISK"

echo "==> partitioning and mounting..."
nix run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --flake "$FLAKE" \
  --impure \
  --yes-wipe-all-disks

echo "==> redirecting tmpdir to disk..."
mkdir -p /mnt/tmp
chmod 1777 /mnt/tmp
export TMPDIR=/mnt/tmp

echo "==> running nixos-install..."
nixos-install --flake "$FLAKE" --no-root-passwd --option accept-flake-config true

echo "==> [success] installation done. rebooting now..."
reboot
