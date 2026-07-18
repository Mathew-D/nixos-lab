{ config, pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true;
  programs.dconf.enable = true;

  security.pam.services.gdm-password.rules.session.mkHome = {
    order = 120;
    control = "optional";
    modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
    args = [
      "skel=/etc/skel"
      "umask=0077"
    ];
  };


 services.gdm-back = {
    enable = true;
    backgroundImage = ./gdm-background.png;
  };

}

