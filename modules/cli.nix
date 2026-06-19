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

    # Optional
    ps_mem

  ];
}
