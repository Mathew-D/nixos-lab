{ config, pkgs, lib, ... }:

let
  cacheIpaUsers = pkgs.writeShellScript "cache-ipa-users" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [
      pkgs.freeipa
      pkgs.gawk
      pkgs.gnugrep
      pkgs.systemd
      pkgs.coreutils
    ]}

    echo "Waiting for FreeIPA..."

    for i in $(seq 1 60); do
      if ipa user-find --pkey-only --all >/dev/null 2>&1; then
        break
      fi

      sleep 2
    done

    if ! ipa user-find --pkey-only --all >/dev/null 2>&1; then
      echo "FreeIPA unavailable"
      exit 1
    fi

    echo "Caching FreeIPA users..."

    ipa user-find --pkey-only --all \
      | awk -F': ' '/User login:/ {print $2}' \
      | while read -r user; do

        echo "Caching $user"

        # Pull user into SSSD cache
        getent passwd "$user" >/dev/null || true

        # Add to AccountsService
        busctl call \
          org.freedesktop.Accounts \
          /org/freedesktop/Accounts \
          org.freedesktop.Accounts \
          CacheUser s "$user" || true

      done

    echo "FreeIPA user cache complete"
  '';

in
{
  # Make sure AccountsService exists
  services.accounts-daemon.enable = true;

  systemd.services.accountsservice-ipa-cache = {
    description = "Cache FreeIPA users into AccountsService";

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