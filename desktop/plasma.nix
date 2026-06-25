{ config, pkgs, ... }:

{
  # Enable X11 (Plasma still depends on it for now in many setups)
  services.xserver.enable = true;

  # KDE Plasma 6
 
  services.desktopManager.plasma6.enable = true;
 security.pam.services.kwallet.enableKwallet = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}

