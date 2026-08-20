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

    greeter-args = "";
    settings = {
      session.default = "Plasma (Wayland)";

      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        corner_radius_scale = 1.0;
        palette = {
          error = "#EE5396";
          hover = "#BE95FF";
          on_error = "#161616";
          on_hover = "#161616";
          on_primary = "#161616";
          on_secondary = "#161616";
          on_surface = "#F2F4F8";
          on_surface_variant = "#DDE1E6";
          on_tertiary = "#161616";
          outline = "#3D3D3D";
          primary = "#33B1FF";
          secondary = "#42BE65";
          shadow = "#000000";
          surface = "#161616";
          surface_variant = "#262626";
          tertiary = "#BE95FF";
        };
        wallpaper = {
          path = "/var/lib/noctalia-greeter/wallpaper.png";
          fill_mode = "crop";
        };
      };

      cursor = {
        theme = "Adwaita";
        size = 24;
      };
    };
  };
}