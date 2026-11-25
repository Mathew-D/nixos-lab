#!/usr/bin/env bash
# Rebuild every lab host over ssh from teacher.
# lab01 goes first so its nix-serve cache is warm for the rest.
#
# Prerequisites:
#   - commit & push from teacher first; each host rebuilds its own
#     ~/nixos-lab checkout (flakes can't see uncommitted files)
#   - run on a machine that can ssh to *.bhs.local without a password
set -uo pipefail

LOGDIR="${XDG_RUNTIME_DIR:-/tmp}/lab-rebuild-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$LOGDIR"
echo "logs: $LOGDIR"

rebuild() {
  local host="$1"
  ssh -o BatchMode=yes -o ConnectTimeout=10 "$host.bhs.local" \
    "cd ~/nixos-lab && git pull --ff-only && sudo nixos-rebuild switch --accept-flake-config --flake '.#$host'" \
    >"$LOGDIR/$host.log" 2>&1
}

echo "== lab01 (cache server) =="
if ! rebuild lab01; then
  echo "lab01 failed; see $LOGDIR/lab01.log" >&2
  exit 1
fi

echo "== lab02..lab32 (parallel) =="
pids=()
for i in $(seq -w 2 32); do
  h="lab$i"
  rebuild "$h" &
  pids+=("$!:$h")
done

failed=()
for pid_host in "${pids[@]}"; do
  pid="${pid_host%%:*}"
  h="${pid_host##*:}"
  if ! wait "$pid"; then
    failed+=("$h")
  fi
done

echo "== summary =="
if ((${#failed[@]})); then
  printf 'FAILED: %s\n' "${failed[@]}"
  echo "logs: $LOGDIR"
  exit 1
fi
echo "all hosts rebuilt OK — logs: $LOGDIR"
