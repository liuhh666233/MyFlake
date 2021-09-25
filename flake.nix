{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    datawarehouse.url =
      "git+ssh://git@github.com/quant-wonderland/data-warehouse?rev=f2a4e59189a65aa4293692d2774d69d745c39b68";
    datawarehouse.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
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
                })
              ];
            })

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
