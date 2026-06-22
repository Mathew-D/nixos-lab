{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core
    curl
    wget
    git
    file
    unzip
    zip

    # Modern CLI tools
    fd
    ripgrep
    bat
    eza
    fzf

    # Utilities
    ps_mem
    tree
    btop
    wl-clipboard
    wayland-utils
    brightnessctl
    xwayland-satellite # xwayland support

    #Dev Tools
    jdk25
    openjfx
    libXtst
    glib
    gtk3


    mesa
    libglvnd
    vulkan-loader
    vulkan-tools
    
    (python314.withPackages (ps: with ps; [
      pyside6
    ]))

    qt6Packages.qttools
    #qt6.qttools
    #qt6.base
    
    libX11
    libXcursor
    libXi
    libXrandr
    libXinerama
    libxkbcommon
    libXxf86vm
    gcc
    rustc
    cargo
    rustup
  ];


  
}
