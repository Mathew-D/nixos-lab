{ config, pkgs, lib, ... }:

{
  environment.etc."greetd/background.png".source = ./gdm-background.png;

security.pam.services.greetd.rules.session.mkHome = {
  order = 120;
  control = "optional";
  modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
  args = [
    "skel=/etc/skel"
    "umask=0077"
  ];
};

  environment.etc."greetd/gtkgreet.css".text = ''
    window {
      background-image: url("file:///etc/greetd/background.png");
      background-size: cover;
      background-position: center;
    }

    * {
      color: red;
    }
  '';

  environment.etc."greetd/environments".text = ''
    dbus-run-session startplasma-wayland
    dbus-run-session niri-session
  '';

  environment.systemPackages = with pkgs; [
    gtkgreet
    cage
  ];

  services.greetd = {
    enable = true;

    settings.default_session = {
      user = "greeter";

      command = ''
        ${pkgs.cage}/bin/cage -s -- \
          ${pkgs.gtkgreet}/bin/gtkgreet \
          -s /etc/greetd/gtkgreet.css \
          -c "dbus-run-session startplasma-wayland"
      '';
    };
  };
}