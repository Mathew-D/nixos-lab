{ config, pkgs, ... }:

{
programs.niri.enable = true;
services.gnome.gnome-keyring.enable = true; 
}

