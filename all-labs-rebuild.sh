#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/nixos-lab-ranges"
mkdir -p "$state_dir"

clear_ranges() {
  find "$state_dir" -maxdepth 1 -type f -name '*.lock' -delete
  echo "Cleared active rebuild range locks."
}

list_active_ranges() {
  shopt -s nullglob
  files=("$state_dir"/*.lock)
  if (( ${#files[@]} == 0 )); then
    echo "No active rebuild ranges."
    return 0
  fi

  echo "Active rebuild ranges:"
  for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
      if ! read -r pid start end < "$file" 2>/dev/null; then
        continue
      fi
      if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$file"
        continue
      fi
      echo "  PID $pid: $start-$end"
    fi
  done
}

check_overlap() {
  local new_start="$1"
  local new_end="$2"
  shopt -s nullglob
  local files=("$state_dir"/*.lock)

  for file in "${files[@]}"; do
    [[ -f "$file" ]] || continue
    if ! read -r pid other_start other_end < "$file" 2>/dev/null; then
      continue
    fi

    if [[ "$pid" == "$$" ]]; then
      continue
    fi

    if ! kill -0 "$pid" 2>/dev/null; then
      rm -f "$file"
      continue
    fi

    if (( new_start <= other_end && new_end >= other_start )); then
      echo "Range $new_start-$new_end overlaps with active range $other_start-$other_end (PID $pid)." >&2
      exit 1
    fi
  done
}

if [[ "${1:-}" == "--clear" || "${1:-}" == "-c" ]]; then
  clear_ranges
  exit 0
fi

if [[ "${1:-}" == "--list" || "${1:-}" == "-l" ]]; then
  list_active_ranges
  exit 0
fi

start="${1:-1}"
end="${2:-32}"

if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 [START END]" >&2
  echo "Example: $0 12 16" >&2
  echo "Example: $0 --list" >&2
  exit 1
fi

if (( start > end )); then
  echo "Start must be less than or equal to end." >&2
  exit 1
fi

check_overlap "$start" "$end"

lock_file="$state_dir/range-$$.lock"
trap 'rm -f "$lock_file"' EXIT
printf '%s %s %s\n' "$$" "$start" "$end" > "$lock_file"

echo "==> Active rebuild ranges:"
list_active_ranges

echo

for i in $(seq "$start" "$end"); do
  host="lab$(printf '%02d' "$i")"
  echo "==> Rebuilding $host"
  nixos-rebuild switch \
    --flake ".#$host" \
    --target-host "${host}.bhs.local" \
    --sudo
  echo "==> Finished $host"
  echo
 done
