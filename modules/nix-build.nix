{ config, pkgs, ... }:

{
  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "sisyphus";
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    sshUser = "lxb";
    sshKey = "/home/lxb/.ssh/id_rsa";
    maxJobs = 1;
  }];
}
