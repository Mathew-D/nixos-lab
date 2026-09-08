{ config, pkgs, inputs, ... }:

{
  imports = [
   ./modules/freeipa-accountsservice.nix
   ./display/greetd.nix
    ./desktop/niri.nix
    ./desktop/plasma.nix
    ./users
    ./modules/cli.nix
    ./modules/apps.nix
    ./modules/shell.nix
    ./modules/env.nix
    ./modules/skel.nix
    ./modules/theme.nix
    ./modules/design-tech.nix
  ];

# Turn flakes on and trust Noctalia cache
 nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.networkmanager.settings.main = {
    "rc-manager" = "unmanaged";
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.resolvconf.enable = false;
  networking.nameservers = [ "172.22.14.10" ];
  environment.etc."resolv.conf".text = ''
    nameserver 172.22.14.10
  '';
  networking.firewall.enable = true;
  services.gvfs = {
  enable = true;
  package = pkgs.gnome.gvfs;
};
  #freeipa
  security.ipa = {
    enable = true;
    domain = "bhs.local";
    realm = "BHS.LOCAL";
    server = "ipa.bhs.local";
    basedn = "dc=bhs,dc=local";
    certificate = pkgs.fetchurl {
      url = "http://ipa.bhs.local/ipa/config/ca.crt";
      hash = "sha256-SbbcHlTiJPk8+x6kjIBOWsWMaTBk9dVsCjRgyw0LIdE=";
    };
  };

services.accounts-daemon.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Fonts
fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  nerd-fonts.roboto-mono
];  

  # Clean up old generations
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  #Hardware
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; 
  hardware.amdgpu.opencl.enable = true;

  boot.supportedFilesystems = [ "cifs" ];

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/teacher 0777 root root - -"
  ];

  fileSystems."/mnt/teacher" = {
    device = "//teacher.bhs.local/teacher";
    fsType = "cifs";
    options = [
      "guest"
      "nofail"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "vers=3.0"
      "iocharset=utf8"
      "dir_mode=0777"
      "file_mode=0666"
    ];
  };

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    hplipWithPlugin
  ];
  services.printing.browsing = true;
  services.printing.openFirewall = true;
  services.ipp-usb.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.printers.ensurePrinters = [
    {
      name = "Dell-C2660dn";
      description = "Dell C2660dn color laser";
      deviceUri = "ipp://172.22.14.24/ipp";
      model = "everywhere";
    }
  ];

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}

