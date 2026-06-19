{ pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fish.enable = true;
  };

  users.defaultUserShell = pkgs.fish;
}
