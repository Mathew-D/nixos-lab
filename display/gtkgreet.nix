{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gtkgreet
    cage
  ];
environment.etc."greetd/background.png".source = ./gdm-background.png;
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        user = "greeter";
        command = ''
  ${pkgs.cage}/bin/cage -s -- \
    ${pkgs.greetd.gtkgreet}/bin/gtkgreet \
      --fullscreen \
      --background /etc/greetd/background.png \
      --time \
      --cmd "dbus-run-session ${pkgs.niri}/bin/niri-session"
'';
      };
    };
  };
}