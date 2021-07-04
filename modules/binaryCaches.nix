{ config, pkgs, ... }: 
{ nix = {
    binaryCaches = [ 
      "https://cache.nixos.org/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    trustedBinaryCaches = [
     "https://cache.nixos.org/"
     "https://mirror.sjtu.edu.cn/nix-channels/store"
     "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/"
   ];
  };
}
