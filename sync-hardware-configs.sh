#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
hosts_dir="$repo_root/hosts"

ssh_user="${SSH_USER:-$USER}"
domain="${HOST_DOMAIN:-bhs.local}"
remote_file="/etc/nixos/hardware-configuration.nix"

if [[ ! -d "$hosts_dir" ]]; then
  echo "Could not find hosts directory at $hosts_dir" >&2
  exit 1
fi

mapfile -t host_names < <(find "$hosts_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [[ "${#host_names[@]}" -eq 0 ]]; then
  echo "No host directories found in $hosts_dir" >&2
  exit 1
fi

success_count=0
failure_count=0

echo "Syncing $remote_file from ${#host_names[@]} hosts..."
echo "SSH user: $ssh_user"
echo "Domain: $domain"

for host in "${host_names[@]}"; do
  remote_host="${host}.${domain}"
  output_file="$hosts_dir/$host/hardware-configuration.nix"
  temp_file="$(mktemp --tmpdir "${host}.hardware-configuration.XXXXXX")"

  echo "[$host] Fetching from $remote_host"

  if ssh "$ssh_user@$remote_host" "sudo cat '$remote_file'" >"$temp_file"; then
    mv "$temp_file" "$output_file"
    echo "[$host] Wrote $output_file"
    success_count=$((success_count + 1))
  else
    rm -f "$temp_file"
    echo "[$host] Failed to fetch $remote_file" >&2
    failure_count=$((failure_count + 1))
  fi

done

echo
echo "Completed: $success_count succeeded, $failure_count failed"

if [[ "$failure_count" -gt 0 ]]; then
  exit 1
fi
