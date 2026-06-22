{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kcalc
    
    google-chrome
    nwg-look
    foot
    libreoffice-fresh
    masterpdfeditor4
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

   (writeShellScriptBin "processing" ''
    export _JAVA_OPTIONS="--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED"
    exec ${pkgs.processing}/bin/processing "$@"
  '')

  ];
  programs.firefox.enable = true;

  programs.vscode = {
  enable = true;

  userSettings = {
    "java.jdt.ls.java.home" = "${pkgs.jdk21}/lib/openjdk";
    "java.configuration.runtimes" = [
      {
        name = "JavaSE-21";
        path = "${pkgs.jdk21}/lib/openjdk";
        default = true;
      }
    ];
    "java.jdt.ls.vmargs" = "-Djava.home=${pkgs.jdk21}/lib/openjdk";
  };
};
}
