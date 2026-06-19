{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    kdePackages.kate
    vscode
  ];
  programs.firefox.enable = true;
}
