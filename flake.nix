{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url =
      "github:NixOS/nixpkgs?rev=2ebb6c1e5ae402ba35cca5eec58385e5f1adea04";

    nixpkgs-stable.url =
      "github:NixOS/nixpkgs?rev=a946fb970f985e20d038e9d12c0db68a8b3b2f19";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations";
    wonder-foundations.inputs.nixpkgs.follows = "nixpkgs";

    wonder-modules.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-modules?ref=UpdateAirflow";
    wonder-modules.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable
    , wonder-foundations, wonder-modules, ... }@inputs:
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
          ];
        };

        lxb = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
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
