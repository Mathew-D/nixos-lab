{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    kdePackages.kate
    vscode
    //windsurf
    processing
    libreoffice-fresh
    masterpdfeditor4
  ];
  programs.firefox.enable = true;
}
