{ config, pkgs, lib, ... }: {
  services.redis = {
    enable = true;
    port = 6379;
    openFirewall = true;
    bind = "127.0.0.1";
    vmOverCommit = true;
    appendOnly = true;
    logLevel = "notice";
    databases = 16;
    maxclients = 10000;
    save = [ [ 900 1 ] [ 300 10 ] [ 60 10000 ] ];
    # settings = { dir = lib.mkForce "/var/lib/wonder/warehouse/redis"; };
  };
}
