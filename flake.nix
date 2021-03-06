{

  description = "All of our deployment, period";

  inputs = {

    nixpkgs.url =
      "github:NixOS/nixpkgs?rev=ce6aa13369b667ac2542593170993504932eb836&tag=22.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # wonder foundations
    wonder-foundations.url =
      "git+ssh://git@github.com/quant-wonderland/wonder-foundations?ref=dev/22.05";
    wonder-foundations.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, wonder-foundations, ... }@inputs:
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

        home = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            wonder-foundations.nixosModules.foundation
            wonder-foundations.nixosModules.home-manager
            wonder-foundations.nixosModules.devopsTools
            ./machines/wsl/home-wsl.nix
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
