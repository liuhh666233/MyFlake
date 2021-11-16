{ config, pkgs, ... }:

{
  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "sisyphus";
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    speedFactor = 2;
    maxJobs = 1;
  }];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
