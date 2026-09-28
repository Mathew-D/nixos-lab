#!/usr/bin/env bash
set -euo pipefail

user="${SSH_USER:-${USER:-$(id -un)}}"
domain="${HOST_DOMAIN:-bhs.local}"

for i in $(seq 1 31); do
  host="lab$(printf '%02d' "$i")"
  echo "==> Connecting to ${user}@${host}.${domain}"
  ssh -o ConnectTimeout=10 "${user}@${host}.${domain}" true
  echo
done
