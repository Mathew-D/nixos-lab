{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdm-back;

in {

  options.services.gdm-back = {

    enable = mkOption {
      type = types.bool;
      default = false;
    };

    backgroundImage = mkOption {
      type = types.path;
      description = "GDM background image";
    };

  };


  config = mkIf cfg.enable {

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

  };

}