{ config, pkgs, lib, ... }:

{
  # Background image
  environment.etc."greetd/background.png".source = ./gdm-background.png;

  # gtkgreet CSS
  environment.etc."greetd/gtkgreet.css".text = ''
    window {
      background-image: url("file:///etc/greetd/background.png");
      background-size: contain;
      background-position: center;
      background-repeat: no-repeat;
    }

    * {
      color: white;
      font-size: 18px;
    }

    entry {
      color: white;
      background-color: rgba(0, 0, 0, 0.5);
    }

    button {
      color: white;
      background-color: rgba(0, 0, 0, 0.5);
    }
  '';

  # Commands shown in gtkgreet session dropdown
  environment.etc."greetd/environments".text = ''
    dbus-run-session startplasma-wayland
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
          -b /etc/greetd/background.png \
          -l /etc/greetd/gtkgreet.css
      '';
    };
  };
}