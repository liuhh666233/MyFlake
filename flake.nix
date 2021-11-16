{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    vitalpkgs.url = "github:nixvital/vitalpkgs";
    vitalpkgs.inputs.nixpkgs.follows = "nixpkgs";

    # Use vital-modules, with the same nixpkgs
    vital-modules.url = "github:nixvital/vital-modules";
    vital-modules.inputs.nixpkgs.follows = "nixpkgs";

    datawarehouse.url =
      "git+ssh://git@github.com/quant-wonderland/data-warehouse";
    datawarehouse.inputs.nixpkgs.follows = "nixpkgs";

    wonder-devops.url =
      "git+ssh://git@github.com/quant-wonderland/devops-tools.git";
    wonder-devops.inputs.nixpkgs.follows = "nixpkgs";

    wonder-deployhub.url =
      "git+ssh://git@github.com/quant-wonderland/deployhub.git";
    wonder-deployhub.inputs.nixpkgs.follows = "nixpkgs";
    wonder-deployhub.inputs.vital-modules.follows = "vital-modules";
    wonder-deployhub.inputs.devops-tools.follows = "wonder-devops";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {

        lxb = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./machines/lxb
            ({
              nixpkgs.overlays = [
                (final: prev: {
                  warehouse = inputs.datawarehouse.defaultPackage."${system}";

                  dp-webui =
                    inputs.datawarehouse.inputs.data-pipeline-webui-flake.defaultPackage."${system}";

                  grafana-latest = pkgs-unstable.grafana;

                  google-chrome-latest = pkgs-unstable.google-chrome;
                })
              ];
            })
            inputs.wonder-deployhub.nixosModules.warehouser
          ];
        };

        demo-vm = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [ ./machines/demo-vm ];
        };

      };

      devShell."${system}" = pkgs.mkShell rec {
        name = "nix-demo-env";

        buildInputs = with pkgs;
          [
            (python38.withPackages (ps:
              with ps; [
                jupyter
                jupyter_core
                notebook
                ipython
                ipykernel
                systemd
                autopep8
                pip
              ]))
          ];

        shellHook = ''
          export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
        '';
      };

    };
}
