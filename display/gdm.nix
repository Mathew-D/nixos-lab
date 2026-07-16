{ config, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  
 security.pam.services.gdm-password.rules.mkHome = {
  order = 120;
  control = "optional";
  modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
  args = [
    "skel=/etc/skel"
    "umask=0077"
  ];
};
}

