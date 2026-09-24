{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab23";
  networking.domain = "bhs.local";
}
