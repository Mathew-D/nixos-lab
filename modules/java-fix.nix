{ pkgs, ... }:

let
  jdkWithFx =
    pkgs.callPackage
      ({ stdenvNoCC, jdk, lib, makeWrapper, libXxf86vm, glib, libXtst, libGL }:
        stdenvNoCC.mkDerivation {
          pname = "jdk-with-fx";
          version = "25";

          nativeBuildInputs = [ makeWrapper ];
          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin

            for f in ${jdk}/bin/*; do
              makeWrapper $f $out/bin/''${f##*/} \
                --prefix LD_LIBRARY_PATH : ${
                  lib.makeLibraryPath [
                    libXxf86vm
                    glib
                    libXtst
                    libGL
                  ]
                }
            done

            ln -s ${jdk}/lib $out/lib
          '';
        })
      {
        jdk = pkgs.jdk25;
      };
in
{
  environment.systemPackages = [
    jdkWithFx
    pkgs.openjfx
    pkgs.maven
  ];
}