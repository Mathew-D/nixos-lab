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

    # Use a separate Kerberos cache for the service
    export KRB5CCNAME=/run/ipa-cache.krb5cc

    echo "Getting Kerberos ticket from host keytab..."
    kinit -kt /etc/krb5.keytab

BASEDN="dc=bhs,dc=local"
    echo "Searching IPA users..."

    ldapsearch \
      -LLL \
      -Y GSSAPI \
      -b "cn=users,cn=compat,$BASEDN" \
      "(objectClass=posixAccount)" uid |
      awk '/^uid:/ {print $2}' |
      while read -r user; do

        echo "Caching $user"

        # Force SSSD to resolve/cache the account
        getent passwd "$user" >/dev/null || true

        # Cache in AccountsService
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
      User = "root";
    };
  };
}