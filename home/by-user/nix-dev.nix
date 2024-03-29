{ pkgs, ... }:

{
  home.packages = [ pkgs.fd pkgs.home-manager pkgs.oh-my-fish ];
  # ...other config, other config...
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  #   programs.zsh.enable = true;
  # Or any other shell you're using.
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      "gs" = "git status";
      "ga" = "git add";
      "gl" = "git log";
      "gp" = "git push";
      "gc" = "git commit -m";
      "gb" = "git branch";
      "gd" = "git diff";
      "cc" = "code -n";
      "pr" = "poetry run";
      "pt" = "poetry run pytest -v";
    };

    shellInit = ''
      source (${pkgs.z-lua}/bin/z --init fish | psub)

      set fzf_fd_opts --hidden --exclude=.git

      fzf_configure_bindings --git_status=\cg --history=\ch --processes=\co --variables --directory --git_log

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
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name="foreign-env";
        src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
            sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
  };
}
