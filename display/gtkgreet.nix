{ config, pkgs, lib, ... }:

{
  # Background image for gtkgreet
  environment.etc."greetd/background.png".source = ./gdm-background.png;

  # GTK CSS for gtkgreet
  environment.etc."greetd/gtkgreet.css".text = ''
    window {
      background-image: url("/etc/greetd/background.png");
      background-size: cover;
      background-position: center;
    }

    #user_entry,
    #password_entry {
      font-size: 18px;
    }

    button {
      font-size: 18px;
    }
  '';

  environment.systemPackages = with pkgs; [
    gtkgreet
    cage
  ];

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        user = "greeter";

        command = ''
          ${pkgs.cage}/bin/cage -s -- \
            ${pkgs.gtkgreet}/bin/gtkgreet \
              -c /etc/greetd/gtkgreet.css
        '';
      };
    };
  };
}