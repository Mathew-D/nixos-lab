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

HOSTS=(lab{01..32})
total=${#HOSTS[@]}

rebuild() {
  local host="$1"
  if ssh -o BatchMode=yes -o ConnectTimeout=10 "$host.bhs.local" \
      "cd ~/nixos-lab && git pull --ff-only && sudo nixos-rebuild switch --accept-flake-config --flake '.#$host'" \
      >"$LOGDIR/$host.log" 2>&1; then
    touch "$LOGDIR/$host.done"
  else
    touch "$LOGDIR/$host.failed"
    echo "$host" >>"$LOGDIR/failed.txt"
  fi
}

echo "== lab01 (cache server) =="
rebuild lab01
if [[ -f $LOGDIR/lab01.failed ]]; then
  echo "lab01 failed; see $LOGDIR/lab01.log" >&2
  exit 1
fi

# Approximate closure size, used to estimate fleet download progress.
TOTAL_PATHS=$(ssh -o BatchMode=yes -o ConnectTimeout=10 lab01.bhs.local \
  'nix-store -qR /run/current-system | wc -l' 2>/dev/null || echo 0)
echo "estimated closure: $TOTAL_PATHS paths per host"

echo "== lab02..lab32 (parallel) =="
for h in "${HOSTS[@]:1}"; do
  rebuild "$h" &
done

# Progress meter: poll marker files every 30s.
# Percent is coarse (hosts finish near-simultaneously), so also show
# each running host's current nixos-rebuild stage from its log.
while :; do
  finished=$(find "$LOGDIR" -maxdepth 1 \( -name '*.done' -o -name '*.failed' \) | wc -l)
  (( finished >= total )) && break
  running=()
  for h in "${HOSTS[@]}"; do
    [[ -f $LOGDIR/$h.done || -f $LOGDIR/$h.failed ]] || running+=("$h")
  done
  # Group running hosts by current stage; name hosts only for
  # non-"copying" stages so the line stays short during bulk downloads.
  declare -A count=() names=()
  fetched=0
  for h in "${running[@]}"; do
    stage=$(grep -aEo 'building the system configuration|copying path|activating the configuration|reloading the following|stopping the following|starting the following|switching to' \
      "$LOGDIR/$h.log" 2>/dev/null | tail -1)
    case "$stage" in
      "building the system configuration") stage="building" ;;
      "copying path") stage="copying" ;;
      "activating the configuration") stage="activating" ;;
      "reloading the following"*) stage="reloading" ;;
      "stopping the following"*) stage="stopping" ;;
      "starting the following"*) stage="starting-units" ;;
      "switching to"*) stage="switching" ;;
      *) stage="starting" ;;
    esac
    count[$stage]=$(( ${count[$stage]:-0} + 1 ))
    names[$stage]="${names[$stage]:-} $h"
    n=$(grep -ac 'copying path' "$LOGDIR/$h.log" 2>/dev/null || true)
    fetched=$(( fetched + ${n:-0} ))
  done
  fetch_pct=0
  if (( TOTAL_PATHS > 0 && ${#running[@]} > 0 )); then
    est=$(( ${#running[@]} * TOTAL_PATHS ))
    fetch_pct=$(( fetched * 100 / est ))
    (( fetch_pct > 100 )) && fetch_pct=100
  fi
  parts=()
  for stage in starting building copying activating reloading stopping starting-units switching; do
    c=${count[$stage]:-0}
    (( c == 0 )) && continue
    if [[ $stage == copying ]]; then
      parts+=("$c copying")
    else
      parts+=("$c $stage (${names[$stage]# })")
    fi
  done
  printf '%s  hosts %d/%d — fleet fetch ~%d%% — %s\n' \
    "$(date +%H:%M:%S)" "$finished" "$total" "$fetch_pct" "${parts[*]}"
  sleep 30
done
wait

echo "== summary =="
if [[ -s $LOGDIR/failed.txt ]]; then
  echo "FAILED:"
  cat "$LOGDIR/failed.txt"
  echo "logs: $LOGDIR"
  exit 1
fi
echo "all $total hosts rebuilt OK — logs: $LOGDIR"
