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

    trustedBinaryCaches = [
      "http://${IPaddressPorts.sisyphus}:${
        toString IPaddressPorts.nixServerPort
      }/"
    ];
  };
}
