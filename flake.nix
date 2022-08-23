{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url =
      "github:NixOS/nixpkgs?rev=ce6aa13369b667ac2542593170993504932eb836&tag=22.05";

    nixpkgs-21.url =
      "github:NixOS/nixpkgs?rev=64fc73bd74f04d3e10cb4e70e1c65b92337e76db&tag=nixos-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations?ref=dev/22.05";
    wonder-foundations.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-21, nixpkgs-unstable, wonder-foundations
    , ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      pkgs-21 = import nixpkgs-21 {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    in {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
            ./machines/wsl
            ({
              nixpkgs.overlays =
                [ (final: prev: { nodejs-14_x = pkgs-21.nodejs-14_x; }) ];
            })
          ];
        };

        home-wsl = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
            ./machines/wsl/home-wsl.nix
          ];
        };

        dev = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
            ./machines/dev
          ];
        };

        nas = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
            ./machines/nas
          ];
        };

        demo-vm = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [ ./machines/demo-vm ];
        };

      };
    };
}
