{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";

    wonder-deployhub.url =
      "git+ssh://git@github.com/quant-wonderland/deployhub.git?ref=master";
    wonder-deployhub.inputs.vital-modules.follows = "vital-modules";

    airflow-dags.url =
      "git+ssh://git@github.com/quant-wonderland/airflow-dags.git?ref=master";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, vital-modules, ... }@inputs:
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
            vital-modules.nixosModules.foundation
            ({
              nixpkgs.overlays = [
                (final: prev: {

                  grafana-latest = pkgs-unstable.grafana;

                  fastavro = pkgs-unstable.python38Packages.fastavro;

                  teams = pkgs-unstable.teams;

                  google-chrome-latest = pkgs.google-chrome;

                  airflow-dags = inputs.airflow-dags.defaultPackage."${system}";

                  airflow-python =
                    inputs.airflow-dags.packages."${system}".airflow-python;

                })
              ];
            })
            inputs.wonder-deployhub.nixosModules.warehouser
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
