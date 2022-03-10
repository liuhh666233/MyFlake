{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    controlMaster = "auto";
    serverAliveInterval = 3;
    serverAliveCountMax = 10;

    matchBlocks = {
      "*" = { identityFile = "~/.ssh/id_rsa"; };

      "wonder" = {
        user = "wonder";
        hostname = "192.168.110.59";
        port = 22;
      };

      "sisyphus" = {
        hostname = "192.168.110.207";
        port = 22;
      };

      "bishop" = {
        hostname = "192.168.110.161";
        port = 22;
      };

      "thor" = {
        hostname = "192.168.110.138";
        port = 22;
      };

      "remote" = {
        hostname = "161.189.132.45";
        port = 9000;
      };

      "bishop_remote" = {
        hostname = "192.168.110.161";
        port = 22;
        proxyJump = "remote";
      };
    };
  };
}
