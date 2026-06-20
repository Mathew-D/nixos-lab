{ config, pkgs, ... }:

{
  imports = [
    ./desktop/plasma.nix
    ./users
    ./modules/cli.nix
    ./modules/apps.nix
    ./modules/shell.nix
    ./modules/env.nix
  ];

# Turn flakes on
 nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;


  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Clean up old generations
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}

