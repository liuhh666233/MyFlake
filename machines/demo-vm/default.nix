{ config, pkgs, ... }:

{
    users.users.root.initialPassword = "xxxx";

    environment.systemPackages = with pkgs; [
    ];
    
}