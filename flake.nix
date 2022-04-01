{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";
    vital-modules.inputs.nixpkgs.follows = "nixpkgs";

    wonder-modules.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-modules.git?ref=UpdateFoundationModule";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, vital-modules, wonder-modules
    , ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    in {
      nixosConfigurations = {
        lxb = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-modules.nixosModules.foundation
            wonder-modules.nixosModules.warehouser
            wonder-modules.nixosModules.devopsTools
            ({
              nixpkgs.overlays = [
                (final: prev: {
                  flameshot = pkgs-unstable.flameshot;
                  google-chrome = pkgs.google-chrome;
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
