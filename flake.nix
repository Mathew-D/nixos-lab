{
  description = "NixOS system - BHS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
 
  noctalia-greeter = {
    url = "github:noctalia-dev/noctalia-greeter";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  noctalia = {
    url = "github:noctalia-dev/noctalia";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  };

outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";

    mkHost = name: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/${name}.nix ];
    };

    hosts = [ "lab01" "lab02" ];
  in {
    nixosConfigurations = builtins.listToAttrs (
      map (name: {
        name = name;
        value = mkHost name;
      }) hosts
    );
  };
}
