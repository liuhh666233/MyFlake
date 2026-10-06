{ lib, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = lib.mkDefault "lxb";
        email = "liuxiaobo666233@gmail.com";
      };
      push.autoSetupRemote = true;
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };

  # 刻意不设 hosts：设了以后 hosts.yml 变成只读链接，`gh auth switch` 写不进去。
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };
}
