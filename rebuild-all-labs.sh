#!/usr/bin/env bash
set -euo pipefail

for i in $(seq 1 32); do
  host="lab$(printf '%02d' "$i")"
  echo "==> Rebuilding $host"
  nixos-rebuild switch \
    --flake ".#$host" \
    --target-host "${host}.bhs.local" \
    --sudo
  echo "==> Finished $host"
  echo
 done
