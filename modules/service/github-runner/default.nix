{ config, pkgs, ... }: {
  config = {

    services.github-runner = {
      enable = true;
      url = "https://github.com/quant-wonderland";
      tokenFile = "/home/lxb/github_action/actions-runner/nixos.token";
      name = "nixos-test";
    };

  };
}
