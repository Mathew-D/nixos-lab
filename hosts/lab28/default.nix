{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lab28";
  networking.domain = "bhs.local";
}
