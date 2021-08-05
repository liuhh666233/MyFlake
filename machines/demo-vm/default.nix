{ config, pkgs, ... }:

{
    users.users.root.initialPassword = "xxxx";

    environment.systemPackages = with pkgs; [
        borgbackup
    ];
    
    services.borgbackup.repos = {
        backup_repos = {
            authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdOZ8cHGtI5ZCQCnNdFFAWL5lYhPCQk0fvU8gyv6/Uh root@nixos"
            ] ;
            path = "/var/lib/backup" ;
        };
    };

    services.borgbackup.jobs = {
        backupToLocalServer = {
            paths = [ "/home/lxb/github" ];
            doInit = true;
            repo =  "borg@nixos:." ;
            encryption = {
                mode = "repokey-blake2";
                passCommand = "cat /run/keys/passwd";
            };
            environment = { BORG_RSH = "ssh -i /run/keys/id_ed25519_backup"; };
            compression = "auto,lzma";
            startAt = "daily";
        };
    };
}