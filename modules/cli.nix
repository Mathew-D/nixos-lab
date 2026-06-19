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

  ];
}
