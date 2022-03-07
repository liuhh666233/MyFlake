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

    airflow-dags.url =
      "git+ssh://git@github.com/quant-wonderland/airflow-dags.git?ref=master";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, vital-modules, ...
    }@inputs:
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
      mkHomeManagerModule = { user, imports }:
        { config, ... }: {
          imports = [ (home-manager.nixosModules.home-manager) ];
          home-manager = {
            # This is needed to make sure that home-manager follows the
            # pkgs/nixpkgs specified in this flake.
            #
            # Relevant github issue: https://github.com/divnix/devos/issues/30
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          home-manager.users."${user}" = { inherit imports; };
        };
    in {

      nixosModules.lxb-home = mkHomeManagerModule {
        user = "lxb";
        imports = [ ./by-user/lxb ];
      };

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

                  cloudflared = pkgs-unstable.cloudflared;

                  google-chrome-latest = pkgs.google-chrome;

                  airflow-dags = inputs.airflow-dags.defaultPackage."${system}";

                  airflow-python =
                    inputs.airflow-dags.packages."${system}".airflow-python;

                  home-manager = inputs.home-manager.defaultPackage."${system}";

                })
              ];
            })
            inputs.wonder-deployhub.nixosModules.warehouser
            self.nixosModules.lxb-home
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
