{ pkgs, ... }:

{
  environment.variables = {
  #  _JAVA_OPTIONS =
  #    "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED";
    NIXOS_OZONE_WL = "1";
    # future variables
    BROWSER = "firefox";
    #QT_QPA_PLATFORMTHEME="gtk3";
    SYSTEMD_EDITOR="nano";
    EDITOR="nano";
    VISUAL="nano";
    TERMINAL="foot";
    #JAVA_HOME = "/run/current-system/sw/lib/openjdk";

LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    #Rust 
    libX11
    libXi
    libxkbcommon
    libGL
    

    #Java
    libXxf86vm
    glib
    libXtst

    #Not needed
    #libXcursor
    #libXrandr
    #libXinerama
    #gtk3
    #libXext
    #mesa
 
  ];



  };
}
