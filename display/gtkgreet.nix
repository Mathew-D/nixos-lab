{ config, pkgs, lib, ... }:

{
  environment.etc."greetd/background.png".source = ./gdm-background.png;

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
          -b /etc/greetd/background.png
      '';
    };
  };
}