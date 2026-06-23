{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kcalc
    nautilus
    google-chrome
    nwg-look
    foot
    vscode
    libreoffice-fresh
    masterpdfeditor4
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    scenebuilder
   (writeShellScriptBin "processing" ''
    export _JAVA_OPTIONS="--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED"
    exec ${pkgs.processing}/bin/processing "$@"
  '')

  ];
  programs.firefox.enable = true;


}
