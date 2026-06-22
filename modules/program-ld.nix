{
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    libX11
    libXcursor
    libXi
    libXrandr
    libXinerama
    libxkbcommon
  ];
}