{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab10";
  networking.domain = "bhs.local";
}
