{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "lab15";
  networking.domain = "bhs.local";
}
