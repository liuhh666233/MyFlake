{ config, pkgs, ... }: {
  services.jupyter = {
    enable = true;
    ip = "localhost";
    port = 5555;
    notebookDir = "/home/lxb/python";
    user = "lxb";
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
            boto
            boto3
            pytz
            matplotlib
            websockets
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
