{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";
    vital-modules.inputs.nixpkgs.follows = "nixpkgs";

    wonder-deployhub.url =
      "git+ssh://git@github.com/quant-wonderland/deployhub.git?ref=master";
    wonder-deployhub.inputs.vital-modules.follows = "vital-modules";
    wonder-deployhub.inputs.nixpkgs.follows = "nixpkgs";

    wonder-modules.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-modules.git?ref=master";

    airflow-dags.url =
      "git+ssh://git@github.com/quant-wonderland/airflow-dags.git?ref=master";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, vital-modules
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
            vital-modules.nixosModules.foundation
            wonder-modules.nixosModules.warehouser
            wonder-modules.nixosModules.devopsTools
            ({
              nixpkgs.overlays = [
                (final: prev: {

                  google-chrome-latest = pkgs.google-chrome;

                  airflow-dags = inputs.airflow-dags.defaultPackage."${system}";

                  airflow-python =
                    inputs.airflow-dags.packages."${system}".airflow-python;

                  home-manager = inputs.home-manager.defaultPackage."${system}";

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
