{ config, pkgs, lib, ... }:

let cfg = config.vital.jupyter-notebook;

in {
  options.vital.jupyter-notebook = with lib; {
    enable = mkEnableOption "Enable the Jupyter Notebook service.";

    user = mkOption {
      type = types.str;
      description = "The user under which the server runs.";
      default = "lxb";
      example = "MyUserName";
    };

    port = mkOption {
      type = types.port;
      description = "The port on which jupyter is served.";
      default = 5555;
      example = 5555;
    };

    configPath = mkOption {
      type = types.path;
      description = "The path of config.";
      default = "/home/lxb/.jupyter/jupyter_notebook_config.py";
      example = "/home/user/config.py";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.jupyter-notebook = {
      description = "Long running Jupyter notebook server.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "users";
        ExecStart = ''
          ${pkgs.jupyter}/bin/jupyter notebook  \
          --no-browser --port ${toString cfg.port} --ip 0.0.0.0 
          --config ${cfg.configPath}
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
