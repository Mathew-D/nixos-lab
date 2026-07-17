{ config, pkgs, lib, ... }:

{
  environment.etc."greetd/background.png".source = ./gdm-background.png;

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

    settings.default_session = {
      user = "greeter";

      command = ''
        ${pkgs.cage}/bin/cage -s -- \
          env GTK_CSS_FILE=/etc/greetd/gtkgreet.css \
          ${pkgs.gtkgreet}/bin/gtkgreet
      '';
    };
  };

  services.displayManager.sessionPackages = [
    pkgs.kdePackages.plasma-workspace
  ];
}