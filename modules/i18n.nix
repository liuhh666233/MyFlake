{ config, pkgs, lib, ... }:

{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  time.timeZone = "Asia/Shanghai";

  location = {
    latitude = 23.0;
    longitude = 113.0;
  };

  systemd.services.inputMethod = {
    description = "Start inputMethod.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "/nix/store/wv35g5lff84rray15zlzarcqi9fxzz84-bash-4.4-p23/bin/bash -e /nix/store/vng7i5ilp17m6j41xy4nxjzrpb8fp3zh-unit-script-fcitx5-daemon-start/bin/fcitx5-daemon-start";
      KillMode = "process";
      Restart = "on-failure";
    };
  };
}
