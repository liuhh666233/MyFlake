# Import this file if you want to enable the flakes feature

{ pkgs, ... }:

{
  config = {
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    
    environment.systemPackages = with pkgs; [
      git openssh
    ];
  };
}
