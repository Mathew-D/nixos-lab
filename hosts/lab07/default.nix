{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab07";
  networking.domain = "bhs.local";
}
