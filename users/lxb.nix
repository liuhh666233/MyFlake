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
    programs.fish.shellAliases = {
        "gs"="git status";
        "ga"="git add";
        "gl"="git log";
        "gp"="git push";
        "gc"="git commit -m";
        "gb"="git branch";
        "gd"="git diff";
        "grep"="ripgrep";
        "cat"="bat";
        "cc"="code -n";
        "gg"="gedit";
    };
}