{ config, pkgs, lib, ... }:
with lib; {
  services.mysql = {
    enable = false;
    port = 3306;
    package = pkgs.mariadb;
    user = "mysql";
    group = "mysql";
    dataDir = "/var/lib/mysql";
    settings = {
      mysqld = {
        key_buffer_size = "6G";
        table_cache = 1600;
        log-error = "/var/log/mysql_err.log";
        plugin-load-add = [ "server_audit" "ed25519=auth_ed25519" ];
      };
      mysqldump = {
        quick = true;
        max_allowed_packet = "16M";
      };
    };
  };
}
