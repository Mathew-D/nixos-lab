{ pkgs, ... }:

{
  users.users.mdusome = {
    isNormalUser = true;
    description = "Computer";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyxOBVlTaJ3pcALWkJnJIvfLfIA//EoPn7L2tHgy8b7 lab-admin"
    ];
  };
}
