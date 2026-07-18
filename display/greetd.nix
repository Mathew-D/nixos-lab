{ config, pkgs, inputs, ... }:
{
  imports = [
  inputs.noctalia-greeter.nixosModules.default
];

  users.groups.greeter = {};
  users.users.greeter = {
        extraGroups = [
       "greeter" 
       "video"
       ];
  };

 systemd.tmpfiles.rules = [
    "d /var/lib/noctalia-greeter 0755 root root -"
    "C /var/lib/noctalia-greeter/wallpaper.png 0644 root root - ${./wallpaper.png}"
    "C /var/lib/noctalia-greeter/appearance.json 0644 root root - ${./appearance.json}"
    "C /var/lib/noctalia-greeter/greeter.toml 0644 greeter greeter - ${./greeter.toml}"
  ];


security.pam.services.greetd.rules.session.mkHome = {
  order = 120;
  control = "optional";
  modulePath = "${pkgs.linux-pam}/lib/security/pam_mkhomedir.so";
  args = [
    "skel=/etc/skel"
    "umask=0077"
  ];
};

security.pam.services.greetd.kwallet = {
    enable = true;
    forceRun = true;
  };

  services.dbus.packages = with pkgs.kdePackages; [ kwallet ];
  xdg.portal.extraPortals = with pkgs.kdePackages; [ kwallet ];

  systemd.user.services.pam-kwallet-init = {
    description = "Unlock kwallet from pam credentials";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Slice = "background.slice";
      Restart = "no";
    };
  };
  
services.greetd.settings.default_session.user = "greeter";

programs.noctalia-greeter = {
  enable = true;
  package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Optional configuration
  greeter-args = "";
  settings = {
    cursor = {
      theme = "Adwaita";
      size = 24;
    };
  };
};
}