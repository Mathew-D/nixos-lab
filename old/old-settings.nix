#(pkgs.google-chrome.override {
#    commandLineArgs = [ "--password-store=basic" ];
#  })

   #./display/gdm.nix
   # ./display/regreet.nix
   #./display/gtkgreet.nix


     #JAVA_HOME = "/run/current-system/sw/lib/openjdk";
/* #OLD Work seems not be needed
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
*/

 #  _JAVA_OPTIONS =
  #    "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED";