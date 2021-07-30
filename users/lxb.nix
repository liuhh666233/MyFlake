{ config, pkgs, lib, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
            users.lxb = {
            isNormalUser = true;
            initialHashedPassword = lib.mkDefault "$6$c7xWgHnMCJKXlPHK$2Owbgw3Y5z/pgwD76O45nPzuRtABjN.Mr6M.yO1jOteDyVsXSOqgzgkAl1sD1kIowEQRFIoyXT45j8ZLmZ5SF1";
            uid = 1001;
            home = "/home/lxb";
            description = "The user lxb.";
            extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
            shell = pkgs.fish;
        };
    };
    programs.fish.enable = true;
    programs.fish.shellAliases = ''
        alias gs='git status'
        alias ga='git add'
        alias gl='git log'
        alias gp='git push'
        alias gc='git commit -m'
        alias gb='git branch'
        alias gd='git diff'
        alias grep='ripgrep'
        alias cat='bat'
        alias cc='code -n'
        alias gg='gedit'
    '';
}