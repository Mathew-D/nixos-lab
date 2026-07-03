{ config, pkgs, inputs, ... }:
{
  imports = [
  inputs.noctalia-greeter.nixosModules.default
];

  users.groups.greeter = {};
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    home = "/var/lib/noctalia-greeter";
    createHome = true;
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