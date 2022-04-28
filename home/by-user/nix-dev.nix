{ pkgs, ... }:

{
  # ...other config, other config...
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # OR
  #   programs.zsh.enable = true;
  # Or any other shell you're using.

  programs.fish = {
    enable = true;
    shellAliases = {
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
      "pr" = "poetry run";
      "pt" = "poetry run pytest -v";
      "gla" = "glances";
    };
    shellInit = ''
      source (${pkgs.z-lua}/bin/z --init fish | psub)
    '';
  };
}
