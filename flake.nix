{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nix flake lock --override-input nixpkgs "github:NixOS/nixpkgs?rev=b681065d0919f7eb5309a93cea2cfa84dec9aa88"
    utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations?ref=dev/24.11";
    wonder-foundations.inputs.nixpkgs.follows = "nixpkgs";
    wonder-foundations.inputs.home-manager.follows = "home-manager";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ml-pkgs.url = "github:nixvital/ml-pkgs";
    ml-pkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, wonder-foundations, home-manager
    , ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
        overlays = [ inputs.ml-pkgs.overlays.gen-ai ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      pkgs-macos = import nixpkgs {
        system = "aarch64-darwin";
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
                [ (final: prev: { duckdb = pkgs-unstable.duckdb; }) ];
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

      # "https://nix-community.github.io/home-manager/release-notes.html" # sec-release-22.11-highlights
      homeConfigurations.lxb = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          
          {
            home = {
              username = "lxb";
              homeDirectory = "/home/lxb";
              stateVersion = "22.11";
            };
          }
        ];
      };

      homeConfigurations.macos = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-macos;
        modules = [
          ./home/default.nix
          {
            home = {
              username = "lhh";
              homeDirectory = "/Users/lhh";
              stateVersion = "22.11";
            };
          }
        ];
      };

      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          {
            home = {
              username = "nixos";
              homeDirectory = "/home/nixos";
              stateVersion = "22.11";
            };
          }
        ];
      };

      homeConfigurations.wonder = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          {
            home = {
              username = "wonder";
              homeDirectory = "/home/wonder";
              stateVersion = "22.11";
            };
          }
        ];
      };
    };
}
