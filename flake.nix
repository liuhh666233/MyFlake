{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url =
      "github:NixOS/nixpkgs?rev=4d2b37a84fad1091b9de401eb450aae66f1a741e&tag=22.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations?ref=master";
    wonder-foundations.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url =
      "github:nix-community/home-manager?rev=93a69d07389311ffd6ce1f4d01836bbc2faec644";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, wonder-foundations, home-manager
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

      homeConfigurations.lxb = home-manager.lib.homeManagerConfiguration {
        inherit pkgs system;
        username = "lxb";
        homeDirectory = "/home/lxb";
        configuration = import ./home/lxb.nix;
      };
    };
}
