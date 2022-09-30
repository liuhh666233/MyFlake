{ pkgs, ... }:

{
  home.packages = [ pkgs.fd ];
  # ...other config, other config...
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # OR
  #   programs.zsh.enable = true;
  # Or any other shell you're using.
  programs.fzf.enable = true;
  programs.bat.enable = true;
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
      set fzf_fd_opts --hidden --exclude=.git
      fzf_configure_bindings --git_status=\cg --history=\ch --processes=\co --variables --directory --git_log
      set --global hydro_color_pwd blue
      set --global hydro_color_git green
      set --global hydro_color_duration cyan
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
