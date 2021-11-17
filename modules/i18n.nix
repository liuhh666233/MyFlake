{ config, pkgs, ... }:

{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "uim";
      #   fcitx5.addons = [ pkgs.fcitx5-rime ];
    };
  };

  time.timeZone = "Asia/Shanghai";

  location = {
    latitude = 23.0;
    longitude = 113.0;
  };
}
