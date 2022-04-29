{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.lxb = {
      isNormalUser = true;
      home = "/home/lxb";
      shell = pkgs.fish;
    };
  };
}
