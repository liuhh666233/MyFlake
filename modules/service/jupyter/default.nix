{ config, pkgs, ... }: {
  services.jupyter = {
    enable = true;
    ip = "localhost";
    port = 5555;
    notebookDir = "/home/nixos/python";
    user = "nixos";
    group = "users";
    password =
      "'argon2:$argon2id$v=19$m=10240,t=10,p=8$OEgjjTojGX8e+bmi431VBg$WjUsHTZdM2EOIjpwgn5dXw'";
    notebookConfig = "c.NotebookApp.allow_remote_access = True";
    kernels = {
      python3 = let
        env = (pkgs.python3.withPackages (pythonPackages:
          with pythonPackages; [
            jupyter
            jupyter_core
            notebook
            ipython
            ipykernel
            pandas
            scikitlearn
            numpy
            systemd
            click
            jinja2
            clickhouse-driver
            flask
            autopep8
            pip
            pyyaml
            pytz
            matplotlib
            websockets
            black
            PyGithub
            GitPython
            redis
            paramiko
            xmltodict
            lark-parser
          ]));
      in {
        displayName = "Python 3";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
      };
    };
  };
}
