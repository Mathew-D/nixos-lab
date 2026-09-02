{ config, lib, pkgs, ... }: {
  imports = [
    ../../base.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "lab02";
  networking.domain = "bhs.local";
  #networking.hosts."127.0.0.2" = lib.mkForce [ ];
}
