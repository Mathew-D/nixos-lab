#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <hostname> [admin-principal]" >&2
  exit 1
fi

hostname="$1"
admin_principal="${2:-admin@BHS.LOCAL}"
ipa_server="ipa.bhs.local"
basedn="dc=bhs,dc=local"
fqdn="${hostname}.bhs.local"
temp_keytab="$(mktemp --tmpdir "${hostname}.krb5.keytab.XXXXXX")"

cleanup() {
  rm -f "$temp_keytab"
}
trap cleanup EXIT

server_resolution="$(getent hosts "$ipa_server" | awk 'NR == 1 { print $1 }')"
host_resolution="$(getent hosts "$fqdn" | awk 'NR == 1 { print $1 }')"

if [[ -z "$server_resolution" ]]; then
  echo "Could not resolve $ipa_server" >&2
  exit 1
fi

if [[ -z "$host_resolution" ]]; then
  echo "Could not resolve $fqdn" >&2
  exit 1
fi

if [[ "$host_resolution" == 127.* || "$host_resolution" == ::1 ]]; then
  echo "$fqdn resolves to loopback ($host_resolution), refusing to enroll." >&2
  exit 1
fi

echo "Using IPA server $ipa_server at $server_resolution"
echo "Using host identity $fqdn at $host_resolution"

if ! klist -s || ! klist | grep -q "Default principal: $admin_principal"; then
  echo "Requesting Kerberos ticket for $admin_principal"
  kinit "$admin_principal"
fi

ipa-join -s "$ipa_server" -h "$fqdn" -k "$temp_keytab" -b "$basedn" -f
sudo install -m 600 "$temp_keytab" /etc/krb5.keytab
sudo systemctl restart sssd
sudo klist -k /etc/krb5.keytab
echo "Enrollment complete for $fqdn"