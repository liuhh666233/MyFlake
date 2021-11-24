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
    binaryCachePublicKeys = [
      "${IPaddressPorts.sisyphus}:${
        toString IPaddressPorts.nixServerPort
      }:e0r/Sp9h7UI8siGsMhKsK/w4glRrdMLAGhKV1BFJ0nQ="
    ];
    trustedBinaryCaches = [
      "http://${IPaddressPorts.sisyphus}:${
        toString IPaddressPorts.nixServerPort
      }/"
    ];
  };
}
