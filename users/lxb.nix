{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.lxb = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/lxb";
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };
  };

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    "gs" = "git status";
    "gsw" = "git switch";
    "ga" = "git add";
    "gl" = "git log";
    "gp" = "git push";
    "gpp" = "git pull";
    "gc" = "git commit -m";
    "gb" = "git branch";
    "gd" = "git diff";
    "grep" = "rg";
    "cat" = "bat";
    "cc" = "code -n";
    "gg" = "gedit";
  };

  programs.fish.shellInit = ''
    source (${pkgs.z-lua}/bin/z --init fish | psub)
  '';
}
