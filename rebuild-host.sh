#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <hostname>" >&2
  exit 1
fi

hostname="$1"
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "$repo_root"

if [[ ! -d "hosts/$hostname" ]]; then
  echo "Unknown host: $hostname" >&2
  echo "Available hosts:" >&2
  find hosts -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' | sort >&2
  exit 1
fi

sudo rm -f /etc/resolv.conf
printf 'nameserver 172.22.14.10\n' | sudo tee /etc/resolv.conf >/dev/null

sudo nixos-rebuild switch --flake --impure ".#$hostname"