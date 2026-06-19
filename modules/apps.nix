{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kcalc
    
    vscode  
    libreoffice-fresh
    masterpdfeditor4

   (writeShellScriptBin "processing" ''
    export _JAVA_OPTIONS="--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED"
    exec ${pkgs.processing}/bin/processing "$@"
  '')

  ];
  programs.firefox.enable = true;
}
