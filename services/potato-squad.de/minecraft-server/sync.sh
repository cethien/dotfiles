#!/usr/bin/env bash
rsync --rsync-path="sudo mkdir -p /opt/minecraft-server && sudo rsync" -r \
  "$(dirname "$(realpath "$0")")/config" potato-squad.de:/opt/minecraft-server/config
