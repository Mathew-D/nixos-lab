{ pkgs, ... }:

{
  users.users.mdusome = {
    isNormalUser = true;
    description = "Computer";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
