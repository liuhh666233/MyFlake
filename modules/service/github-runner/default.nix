{ config, pkgs, ... }: {
  config = {

    services.github-runner = {
      enable = true;
      url = "https://github.com/quant-wonderland/integration-test";
      tokenFile = "/home/lxb/github_action/actions-runner/nixos.token";
      name = "lxb";
    };

  };
}
