{ config, pkgs, lib, ... }:

{
  # Background image
  environment.etc."greetd/background.png".source = ./gdm-background.png;

  # Packages needed for greetd
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
            ${pkgs.gtkgreet}/bin/gtkgreet
        '';
      };
    };
  };
}