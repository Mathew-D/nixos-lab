{ config, pkgs, ... }: {
  imports = [
    ../base.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "lab02";
}
