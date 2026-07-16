{ config, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;

  security.pam.services.gdm-password.rules.session.mkHome = {
    order = 120;
    control = "optional";
    modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
    args = [
      "skel=/etc/skel"
      "umask=0077"
    ];
  };

  environment.etc."gdm/background.png".source = ./gdm-background.png;

  environment.etc."gdm/custom.css".text = ''
    #lockDialogGroup {
      background: url(file:///etc/gdm/background.png);
      background-size: cover;
      background-position: center;
    }
  '';
}

