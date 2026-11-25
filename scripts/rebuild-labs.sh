#!/usr/bin/env bash
# Rebuild every lab host over ssh from teacher.
# lab01 goes first so its nix-serve cache is warm for the rest.
#
# Prerequisites:
#   - commit & push from teacher first; each host rebuilds its own
#     ~/nixos-lab checkout (flakes can't see uncommitted files)
#   - run on a machine that can ssh to *.bhs.local without a password
set -uo pipefail

rebuild() {
  local host="$1"
  ssh -o BatchMode=yes -o ConnectTimeout=10 "$host.bhs.local" \
    "cd ~/nixos-lab && git pull --ff-only && sudo nixos-rebuild switch --flake '.#$host'"
}

echo "== lab01 (cache server) =="
if ! rebuild lab01; then
  echo "lab01 failed; aborting so the cache isn't expected to be warm" >&2
  exit 1
fi

echo "== lab02..lab32 (parallel) =="
for i in $(seq -w 2 32); do
  rebuild "lab$i" &
done
wait

echo "== done =="
