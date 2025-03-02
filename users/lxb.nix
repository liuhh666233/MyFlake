{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.lxb = {
      isNormalUser = true;
      uid = 1001;
      initialHashedPassword = lib.mkDefault
        "$6$c7xWgHnMCJKXlPHK$2Owbgw3Y5z/pgwD76O45nPzuRtABjN.Mr6M.yO1jOteDyVsXSOqgzgkAl1sD1kIowEQRFIoyXT45j8ZLmZ5SF1";
      description = "The user lxb.";
      home = "/home/lxb";
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };
    programs.nix-ld.enable = true;
  };
}
