{ config, pkgs, ... }:

{
programs.niri.enable = true;
services.gnome.gnome-keyring.enable = true; 

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
       xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
    ];

    config.common.default = "gtk";

};
}

