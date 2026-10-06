{
  description = "Home-manager configurations for lxb / lhh, plus project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # 只给更新快的命令行工具（rtk）用，其余一律走 26.05。
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkPkgs = input: system:
        import input {
          inherit system;
          config.allowUnfree = true;
        };

      # 不写 `#名字` 时，home-manager 和 nh 都按 `用户@主机名` 自动选配置。
      mkHome = { system, username, homeDirectory, host }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs nixpkgs system;
          extraSpecialArgs.pkgs-unstable = mkPkgs nixpkgs-unstable system;
          modules = [
            nix-index-database.homeModules.nix-index
            ./home
            ./home/hosts/${host}.nix
            {
              home = {
                inherit username homeDirectory;
                # 不是当前用的版本号；改之前先读 HM 的 release notes，改错会迁移本机数据。
                stateVersion = "24.11";
              };
            }
          ];
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

      homeConfigurations = {
        "lxb@athena" = mkHome {
          system = "x86_64-linux";
          username = "lxb";
          homeDirectory = "/home/lxb";
          host = "athena";
        };
        "lxb@kami" = mkHome {
          system = "x86_64-linux";
          username = "lxb";
          homeDirectory = "/home/lxb";
          host = "kami";
        };
        "lhh@lhh-macos" = mkHome {
          system = "aarch64-darwin";
          username = "lhh";
          homeDirectory = "/Users/lhh";
          host = "lhh-macos";
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
