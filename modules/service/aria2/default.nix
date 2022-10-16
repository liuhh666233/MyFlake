{ config, pkgs, ... }: {

  services.aria2 = {
    enable = true;
    openPorts = true;
    downloadDir = "/var/lib/wonder/warehouse/Shares/Public/aria2";
    rpcListenPort = 6800;
    extraArguments = "--rpc-listen-all --rpc-allow-origin-all=true";
    rpcSecret = "123456";
  };
  networking.firewall.allowedTCPPorts = [ 6800 ];
}
