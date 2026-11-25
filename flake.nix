{
  description = "NixOS system - BHS";

nixConfig = {
    extra-substituters = [
      "http://lab01.bhs.local:5000"
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];
    extra-trusted-substituters = [ "http://lab01.bhs.local:5000" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
 
  noctalia-greeter = {
    url = "github:noctalia-dev/noctalia-greeter";
    inputs.nixpkgs.follows = "nixpkgs";
  };

devin = {
     url = "github:Mathew-D/devin-desktop-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };


  noctalia = {
  url = "github:noctalia-dev/noctalia/cachix";
  };

  umbriel = {
    url = "github:noctalia-dev/umbriel/cachix";
  };

  pcloud = {
    url = "github:Mathew-D/pcloud-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  euro-office = {
    url = "github:Mathew-D/nix-euro-office";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  };

outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";

    mkHost = name: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [ 
          ./hosts/${name}/default.nix
      ];
    };

    hosts = (builtins.genList (
      i:
      let
        n = i + 1;
      in
      "lab${if n < 10 then "0${toString n}" else toString n}"
    ) 32) ++ [ "teacher" ];
  in {
    nixosConfigurations = builtins.listToAttrs (
      map (name: {
        name = name;
        value = mkHost name;
      }) hosts
    );
  };
}
