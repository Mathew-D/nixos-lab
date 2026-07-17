
 nixpkgs.overlays = [
    (import ./modules/gdm-background-overlay.nix {
      backgroundImage = ./display/gdm-background.png;
    })
  ];