#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
hosts_dir="$repo_root/hosts"

ssh_user="${SSH_USER:-$USER}"
domain="${HOST_DOMAIN:-bhs.local}"
required_host="${REQUIRED_SOURCE_HOST:-lab01}"

if [[ ! -d "$hosts_dir" ]]; then
  echo "Could not find hosts directory at $hosts_dir" >&2
  exit 1
fi

current_host="$(hostname -s)"
if [[ "$current_host" != "$required_host" && "${ALLOW_NON_LAB01:-0}" != "1" ]]; then
  echo "This script must be run on $required_host (current host: $current_host)." >&2
  echo "Set ALLOW_NON_LAB01=1 to override this safety check." >&2
  exit 1
fi

mapfile -t all_lab_hosts < <(find "$hosts_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | grep '^lab[0-9]\{2\}$')

if [[ "${#all_lab_hosts[@]}" -eq 0 ]]; then
  echo "No lab hosts found in $hosts_dir" >&2
  exit 1
fi

targets=()
if [[ "$#" -eq 0 ]]; then
  for host in "${all_lab_hosts[@]}"; do
    [[ "$host" == "$required_host" ]] && continue
    targets+=("$host")
  done
else
  for requested in "$@"; do
    if [[ "$requested" == "all" ]]; then
      targets=()
      for host in "${all_lab_hosts[@]}"; do
        [[ "$host" == "$required_host" ]] && continue
        targets+=("$host")
      done
      break
    fi

    if [[ ! -d "$hosts_dir/$requested" ]]; then
      echo "Unknown host: $requested" >&2
      exit 1
    fi
    targets+=("$requested")
  done
fi

if [[ "${#targets[@]}" -eq 0 ]]; then
  echo "No target hosts selected." >&2
  exit 1
fi

cd "$repo_root"

echo "Source build host: $current_host"
echo "Deploy user: $ssh_user"
echo "Domain: $domain"
echo "Targets: ${targets[*]}"
echo

for host in "${targets[@]}"; do
  remote_host="$host.$domain"

  echo "[$host] Build phase"
  nix build ".#nixosConfigurations.${host}.config.system.build.toplevel"

  echo "[$host] Deploy phase"
  nixos-rebuild switch \
    --flake ".#${host}" \
    --target-host "$ssh_user@$remote_host" \
    --build-host localhost \
    --use-remote-sudo

  echo "[$host] Done"
  echo
done

echo "All selected hosts were updated successfully."