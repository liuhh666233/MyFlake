{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.lhh = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/lhh";
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };
  };
  programs.fish.enable = true
  security.sudo.extraRules = [{
    users = [ "lhh" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
}
