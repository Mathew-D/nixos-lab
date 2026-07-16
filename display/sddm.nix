{ config, pkgs, ... }:
{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
security.pam.services.sddm.rules.session.mkHome = {
  order = 120;
  control = "optional";
  modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
  args = [
    "skel=/etc/skel"
    "umask=0077"
  ];
};
}