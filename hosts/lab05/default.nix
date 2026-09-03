{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "lab05";
  networking.domain = "bhs.local";
}
