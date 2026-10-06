{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nix flake lock --override-input nixpkgs "github:NixOS/nixpkgs?rev=b681065d0919f7eb5309a93cea2cfa84dec9aa88"

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
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
      templates = {
        python-dev-starter = {
          path = ./templates/python-dev-starter;
          description = "Generate a python dev starter package.";
        };
        rust-dev-starter = {
          path = ./templates/rust-dev-starter;
          description = "Generate a rust dev starter package.";
        };
        webapp-dev-starter = {
          path = ./templates/webapp-dev-starter;
          description = "Generate a webapp dev starter package.";
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
              stateVersion = "24.11";
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
              stateVersion = "24.11";
            };
          }
        ];
      };
    };
}
