{ pkgs, ... }:

{
  home.packages = [ pkgs.powertop ];

  home.file.".tmux.conf".text = ''
    set -g mouse on
  '';
}
