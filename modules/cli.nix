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

    #Dev Tools
    jdk21
    
    python314
    python314Packages.pyside6
    qt6.qttools
    
    rustc
    cargo
    rustup
  ];
}
