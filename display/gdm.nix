{ config, pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true;
  programs.dconf.enable = true;

  security.pam.services.gdm-password.rules.session.mkHome = {
    order = 120;
    control = "optional";
    modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
    args = [
      "skel=/etc/skel"
      "umask=0077"
    ];
  };


 services.gdm-back = {
    enable = true;
    backgroundImage = ./gdm-background.png;
  };

  programs.dconf.profiles.gdm.databases = lib.mkBefore [
    {
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${./gdm-background.png}";
          picture-uri-dark = "file://${./gdm-background.png}";
          picture-options = "zoom";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${./gdm-background.png}";
          picture-uri-dark = "file://${./gdm-background.png}";
          picture-options = "zoom";
        };
      };
      locks = [
        "/org/gnome/desktop/background/picture-uri"
        "/org/gnome/desktop/background/picture-uri-dark"
        "/org/gnome/desktop/background/picture-options"
        "/org/gnome/desktop/screensaver/picture-uri"
        "/org/gnome/desktop/screensaver/picture-uri-dark"
        "/org/gnome/desktop/screensaver/picture-options"
      ];
    }
  ];
}

