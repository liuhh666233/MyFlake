{ config, pkgs, lib, ... }:

let
  cfg = config.services.borgbackup;

  backup-service = serviceName: path: repo: {
    user = "lxb";
    group = "users";
    paths = [ path ];
    archiveBaseName = serviceName;
    dateFormat = "+%Y-%m-%dT%H:%M:%S";
    exclude = [ "*.tmp" ];
    doInit = false;
    repo = repo;
    encryption = { mode = "none"; };
    environment.BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
    environment.BORG_RSH = "ssh -i /home/lxb/work/AWS/aws-china.pem";
    compression = "auto,lzma";
    startAt = "daily";
  };
in {

  options.services.borgbackup = with lib; {

    minbarPath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse/archive/minbar/";
      description = "The path of minbar archive file.";
      example = "/var/lib/wonder/warehouse/archive/minbar/";
    };

    tickTradePath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse/archive/tick_trade/";
      description = "The path of tick trade archive file.";
      example = "/var/lib/wonder/warehouse/archive/tick_trade/";
    };

    tickSlicePath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse/archive/tick_slice/";
      description = "The path of tick slice archive file.";
      example = "/var/lib/wonder/warehouse/archive/tick_slice/";
    };

    windPath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse/raw/wind/__DATA__";
      description = "The path of wind row file.";
      example = "/var/lib/wonder/warehouse/raw/wind/__DATA__";
    };

    minbarRepo = mkOption {
      type = types.str;
      default = "datamgr@bishop:minbar";
      description = "The backup repo of minbar.";
      example = "datamgr@bishop:minbar";
    };

    tickSliceRepo = mkOption {
      type = types.str;
      default = "datamgr@bishop:tick_slice";
      description = "The backup repo of tick slice.";
      example = "datamgr@bishop:tick_slice";
    };

    tickTradeRepo = mkOption {
      type = types.str;
      default = "datamgr@bishop:tick_trade";
      description = "The backup repo of tick trade.";
      example = "datamgr@bishop:tick_trade";
    };

    windRepo = mkOption {
      type = types.str;
      default = "datamgr@bishop:wind";
      description = "The backup repo of wind.";
      example = "datamgr@bishop:wind";
    };
  };

  config = {
    services.borgbackup.jobs = {

      minbar-archiver = backup-service "minbar" cfg.minbarPath cfg.minbarRepo;

    };
  };

}
