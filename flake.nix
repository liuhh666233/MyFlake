{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    };

  outputs = { self, nixpkgs, ... }@inputs: 
    {
      nixosConfigurations = {
        
        lxb = nixpkgs.lib.nixosSystem rec{
          system = "x86_64-linux";
          modules = [
            ./machines/lxb
          ];
        };
      };
    };
}
