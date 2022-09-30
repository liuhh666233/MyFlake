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
    plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
        sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      };
    }
    { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
  ];
  };
}
