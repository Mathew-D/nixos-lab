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
    wl-clipboard
    wayland-utils
    brightnessctl
    xwayland-satellite # xwayland support

    #Dev Tools
    jdk21
    
    python314
    python314Packages.pyside6
    qt6.qttools
    
    gcc
    rustc
    cargo
    rustup
  ];
}
