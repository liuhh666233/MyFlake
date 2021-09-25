{ config, pkgs, ... }: {
  nix = {
    binaryCaches = [
      "http://192.168.110.15:5000/"
      "https://cache.nixos.org/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    trustedBinaryCaches = [
      "http://192.168.110.15:5000/"
      "https://cache.nixos.org/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/"
    ];
  };
}
