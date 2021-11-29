{ config, lib, ... }:
let IPaddressPorts = import ./IPaddress-ports.nix;
in {
  nix = {
    binaryCaches = lib.mkForce [
      "http://${IPaddressPorts.sisyphus}:${
        toString IPaddressPorts.nixServerPort
      }/"
      "https://cache.nixos.org/"
    ];
    binaryCachePublicKeys =
      [ "sisyphus-1:A+04lWKcliP1HDMpJZCvjPwM0ZMPjRpU8zijgDsHjpk=" ];
    trustedBinaryCaches = [
      "http://${IPaddressPorts.sisyphus}:${
        toString IPaddressPorts.nixServerPort
      }/"
    ];
  };
}
