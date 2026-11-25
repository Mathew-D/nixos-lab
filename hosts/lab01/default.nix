{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab01";
  networking.domain = "bhs.local";

  # Binary cache for the rest of the lab fleet.
  services.nix-serve = {
    enable = true;
    port = 5000;
    openFirewall = true;
  };
}
