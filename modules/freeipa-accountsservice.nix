{ config, pkgs, lib, ... }:

let
  cacheIpaUsers = pkgs.writeShellScript "cache-ipa-users" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [
      pkgs.krb5
      pkgs.openldap
      pkgs.gawk
      pkgs.coreutils
      pkgs.systemd
    ]}

    echo "Getting Kerberos ticket from host keytab..."
    kinit -k

   BASEDN=$(awk -F'=' '/basedn/ {gsub(/[[:space:]]/, "", $2); print $2}' /etc/ipa/default.conf)

    if [ -z "$BASEDN" ]; then
      echo "Could not determine IPA basedn"
      exit 1
    fi

    echo "Searching IPA users..."

    ldapsearch \
      -LLL \
      -Y GSSAPI \
      -b "cn=users,cn=accounts,$BASEDN" \
      "(objectClass=posixAccount)" uid |
      awk '/^uid:/ {print $2}' |
      while read -r user; do

        echo "Caching $user"

        # Load user through SSSD
        getent passwd "$user" >/dev/null || true

        # Add to AccountsService
        busctl call \
          org.freedesktop.Accounts \
          /org/freedesktop/Accounts \
          org.freedesktop.Accounts \
          CacheUser s "$user" || true

      done

    echo "IPA AccountsService cache complete"
  '';

in
{
  services.accounts-daemon.enable = true;

  systemd.services.accountsservice-ipa-cache = {
    description = "Cache FreeIPA users in AccountsService";

    wantedBy = [
      "graphical.target"
    ];

    before = [
      "greetd.service"
    ];

    after = [
      "network-online.target"
      "sssd.service"
      "accounts-daemon.service"
    ];

    wants = [
      "network-online.target"
    ];

    requires = [
      "sssd.service"
      "accounts-daemon.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = cacheIpaUsers;
      RemainAfterExit = true;
    };
  };
}