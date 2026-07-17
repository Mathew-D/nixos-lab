{ config, pkgs, lib, ... }:

{
  environment.etc."greetd/background.png".source = ./gdm-background.png;

  environment.etc."greetd/gtkgreet.css".text = ''
    window {
      background-image: url("file:///etc/greetd/background.png");
      background-size: cover;
      background-position: center;
    }

    * {
      color: white;
    }
  '';

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
          -s /etc/greetd/gtkgreet.css
      '';
    };
  };
}