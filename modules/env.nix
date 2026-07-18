{ pkgs, ... }:

{
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    # future variables
    BROWSER = "firefox";
    #QT_QPA_PLATFORMTHEME="gtk3";
    SYSTEMD_EDITOR="nano";
    EDITOR="nano";
    VISUAL="nano";
    TERMINAL="foot";
  

  };
}
