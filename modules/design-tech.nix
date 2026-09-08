{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  gimp
  krita
  inkscape
  luanti
  davinci-resolve
  kdePackages.kdenlive
  ];
}
