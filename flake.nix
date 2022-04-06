{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";
    vital-modules.inputs.nixpkgs.follows = "nixpkgs";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations";

    wonder-modules.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-modules";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, vital-modules, wonder-foundations
    , wonder-modules, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    in {
      nixosConfigurations = {
        lxb = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-modules.nixosModules.warehouser
            ({
              nixpkgs.overlays = [
                (final: prev: {
                  flameshot =
                    nixpkgs-unstable.legacyPackages."${prev.system}".flameshot;
                })
              ];
            })
            ./machines/lxb
          ];
        };

        demo-vm = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [ ./machines/demo-vm ];
        };

      };
    };
}
