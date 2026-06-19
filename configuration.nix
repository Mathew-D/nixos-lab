{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktop/plasma.nix
    ./users
    ./modules/cli.nix
    ./modules/gui.nix
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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Firefox (system-wide)
  programs.firefox.enable = true;

  # System-wide packages (shared by all users)
  environment.systemPackages = with pkgs; [
    kdePackages.kate
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}

