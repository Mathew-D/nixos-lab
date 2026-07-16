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

programs.dconf.profiles.gdm.databases = [
  {
    settings = {
      "org/gnome/login-screen" = {
        disable-user-list = true;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file://${./Artboard 1.png}";
        picture-uri-dark = "file://${./Artboard 1.png}";
        picture-options = "zoom";
      };
    };
  }
];
}

