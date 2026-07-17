{ config, pkgs, ... }:

{

  # greetd + regreet
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };


  # regreet configuration
  programs.regreet = {
    enable = true;

    settings = {
      background = {
        path = "/etc/greetd/background.png";
        fit = "Cover";
      };

      appearance = {
        greeting_msg = "FreeIPA Lab Login";
      };

      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Adwaita";
      };
    };
  };


  # Put your wallpaper into the immutable system
  environment.etc."greetd/background.png".source = ./gdm-background.png;


  # Needed packages
  environment.systemPackages = with pkgs; [
    regreet
    adwaita-icon-theme
  ];


  # SSSD / FreeIPA
  services.sssd.enable = true;


  # PAM support
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };


  # Optional: make sure Wayland variables exist
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };
}