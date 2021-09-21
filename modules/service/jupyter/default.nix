{ config, pkgs, lib, ... }:

let
  cfg = config.vital.jupyter-notebook;

  kernels = (pkgs.jupyter-kernel.create {
    definitions =
      if cfg.kernels != null then cfg.kernels else pkgs.jupyter-kernel.default;
  });

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

    kernels = mkOption {
      type = types.nullOr (types.attrsOf
        (types.submodule (import ./kernel-options.nix { inherit lib; })));

      default = null;
      example = literalExample ''
        {
          python3 = let
            env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                    ipykernel
                    pandas
                    scikit-learn
                  ]));
          in {
            displayName = "Python 3 for machine learning";
            argv = [
              "''${env.interpreter}"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            logo32 = "''${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "''${env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        }
      '';
      description = ''
        Declarative kernel config
              Kernels can be declared in any language that supports and has the required
              dependencies to communicate with a jupyter server.
              In python's case, it means that ipykernel package must always be included in
              the list of packages of the targeted environment.
              '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.jupyter-notebook = {
      description = "Long running Jupyter notebook server.";
      after = [ "network.target" ];

      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ bash python ];

      environment = { JUPYTER_PATH = toString kernels; };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "users";
        ExecStart = ''
          ${pkgs.jupyter}/bin/jupyter-notebook  \
          --no-browser --port ${toString cfg.port} --ip 0.0.0.0 \
          --config ${cfg.configPath}
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
