{
  description = "NixOS system - BHS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

 outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";

    mkHost = name: nixpkgs.lib.nixosSystem {
      inherit system;
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
