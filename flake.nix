{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";
    vital-modules.inputs.nixpkgs.follows = "nixpkgs";

    wonder-devops.url =
      "git+ssh://git@github.com/quant-wonderland/devops-tools.git";
    wonder-devops.inputs.nixpkgs.follows = "nixpkgs";

    wonder-deployhub.url =
      "git+ssh://git@github.com/quant-wonderland/deployhub.git?ref=updateWarehouser";
    wonder-deployhub.inputs.nixpkgs.follows = "nixpkgs";
    wonder-deployhub.inputs.vital-modules.follows = "vital-modules";
    wonder-deployhub.inputs.devops-tools.follows = "wonder-devops";

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

                  apache-airflow = pkgs-unstable.apache-airflow;

                  grafana-latest = pkgs-unstable.grafana;

                  google-chrome-latest = pkgs.google-chrome;
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
