{ config, pkgs, ... }:

{


  # FreeIPA / SSSD
  services.sssd.enable = true;

security.pam.services.greetd.rules.session.mkHome = {
  order = 120;
  control = "optional";
  modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
  args = [
    "skel=/etc/skel"
    "umask=0077"
  ];
};

  # greetd + regreet
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        # regreet needs a Wayland compositor
        command = ''
          ${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet
        '';

        user = "greeter";
      };
    };
  };


  # regreet configuration
 programs.regreet = {
  enable = true;

  settings = {
    GTK = {
      application_prefer_dark_theme = true;
    };

    appearance = {
      greeting_msg = "FreeIPA Lab Login";
    };
  };

  extraCss = ''
    window {
      background-image: url("file:///etc/greetd/background.png");
      background-size: cover;
      background-position: center;
    }
  '';
};

  # Background image
  environment.etc."greetd/background.png".source = ./gdm-background.png;


  # Required packages
  environment.systemPackages = with pkgs; [
    cage
    greetd.regreet
    adwaita-icon-theme
  ];


  # PAM integration
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };


  # Wayland environment
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };


  # Niri session
  programs.niri.enable = true;
}