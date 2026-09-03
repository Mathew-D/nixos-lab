{ config, pkgs, ... }: {
  imports = [
    ../../base.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "teacher";
  networking.domain = "bhs.local";

  users.groups.teacher-share = { };
  users.users.teacher-share = {
    isSystemUser = true;
    group = "teacher-share";
  };

  systemd.tmpfiles.rules = [
    "d /srv/teacher 0777 teacher-share teacher-share - -"
  ];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server role" = "standalone server";
        "map to guest" = "Bad User";
        "guest account" = "teacher-share";
      };

      teacher = {
        path = "/srv/teacher";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "teacher-share";
        "force group" = "teacher-share";
        "create mask" = "0666";
        "directory mask" = "0777";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
