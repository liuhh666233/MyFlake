{ ... }:

{
  # 与 lyc 共用 /var/work_space_lyc 下的仓库：新文件要组可写，配合仓库目录上的 setgid。
  programs.fish.shellInit = "umask 002";

  programs.git = {
    settings.safe.directory = "/var/work_space_lyc/*";
    # 身份文件留在仓库外：仓库改私有之前不放别人的邮箱。
    includes = [{
      condition = "gitdir:/var/work_space_lyc/";
      path = "~/.gitconfig-lyc";
    }];
  };
}
