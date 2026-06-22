{ pkgs, ... }:

{
  environment.variables = {
  #  _JAVA_OPTIONS =
  #    "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED";

    # future variables
    BROWSER = "firefox";
    #QT_QPA_PLATFORMTHEME="gtk3";
    SYSTEMD_EDITOR="nano";
    EDITOR="nano";
    VISUAL="nano";
    TERMINAL="foot";
    #JAVA_HOME = "/run/current-system/sw/lib/openjdk";

LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    libX11
    libXcursor
    libXi
    libXrandr
    libXinerama
    libxkbcommon
    libXext
    mesa
    libGL
    libXxf86vm
  ];



  };
}
