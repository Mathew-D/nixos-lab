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
      pkgs.glibc
      pkgs.gnugrep
      pkgs.gnused
      pkgs.getent
    ]}

    export KRB5CCNAME=/run/ipa-cache.krb5cc

    echo "Getting Kerberos ticket from host keytab..."
    kinit -kt /etc/krb5.keytab

    BASEDN="dc=bhs,dc=local"

    IPA_USERS=$(mktemp)
    trap "rm -f $IPA_USERS" EXIT

    echo "Searching IPA users..."

    ldapsearch \
      -LLL \
      -Y GSSAPI \
      -b "cn=users,cn=compat,$BASEDN" \
      "(objectClass=posixAccount)" uid |
      awk '/^uid:/ {print $2}' > "$IPA_USERS"


    #
    # Add/update IPA users in AccountsService
    #
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

    done < "$IPA_USERS"


    #
    # Remove stale IPA users
    #
    for file in /var/lib/AccountsService/users/*; do

      [ -e "$file" ] || continue

      cached_user=$(basename "$file")

      # Never remove local accounts
      case "$cached_user" in
        root|mdusome)
          continue
          ;;
      esac


      if ! grep -qx "$cached_user" "$IPA_USERS"; then

        echo "Removing stale user $cached_user"

        uid=$(id -u "$cached_user" 2>/dev/null || true)

        if [ -n "$uid" ]; then
            rm -f "/var/lib/AccountsService/users/$cached_user"
            echo "Removed AccountsService cache for $cached_user"
        fi

      fi

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