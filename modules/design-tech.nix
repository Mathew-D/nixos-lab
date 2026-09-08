{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  grimp
  krita
  inkscape
  luanti
  davinci-resolve
  kdePackages.kdenlive
  ];
}
