{ config, pkgs, lib, ... }: {
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "1cszfjwshj6imkwip270ln4l1j328aw2zh9vm26wv3asnqlhdrak";
      }
    }/modules/vscode-server/home.nix"
    ./ssh.nix
  ];

  services.vscode-server.enable = true;

  home.packages = [ pkgs.archer ];

  home.file.".config/wonder/archer/config.json".text = ''
    {"remote_host": "bishop", "remote_port": 22, "remote_user": "lxb", "ssh_key": "/home/lxb/.ssh/id_rsa", "remote_warehouse_root": "/var/lib/wonder/warehouse", "local_warehouse_root": "/var/lib/wonder/warehouse","ssh_proxy": ""}'';

}
