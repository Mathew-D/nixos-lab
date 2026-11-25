{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab01";
  networking.domain = "bhs.local";

  # Binary cache for the rest of the lab fleet.
  # Secret key lives at /var/lib/nix-serve/key.secret on lab01 only
  # (generated once with nix-store --generate-binary-cache-key).
  services.nix-serve = {
    enable = true;
    port = 5000;
    openFirewall = true;
    secretKeyFile = "/var/lib/nix-serve/key.secret";
  };
}
