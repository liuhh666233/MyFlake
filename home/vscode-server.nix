{ config, pkgs, lib, ... }:

let
  vscode-server-src = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
    sha256 = "1vgq7141mv67r7xgdpgg54hy41kbhlgp3870kyrh6z5fn4zyb74p";
  };
in {
  imports = [ "${vscode-server-src}/modules/vscode-server/home.nix" ];
  services.vscode-server.enable = true;
  services.vscode-server.nodejsPackage = pkgs.nodejs-16_x;
  # services.vscode-server.enableFHS = true;
  # # services.vscode-server.extraRuntimeDependencies = with pkgs; [
  # #   vscode-extensions.ms-vscode.cpptools
  # #   vscode-extensions.xaver.clang-format
  # #   vscode-extensions.ms-vscode-remote.remote-ssh
  # #   vscode-extensions.ms-python.python
  # #   vscode-extensions.ms-python.vscode-pylance
  # #   vscode-extensions.donjayamanne.githistory
  # # ];
}
