{
  programs = {
    git = {
      enable = true;
      userName = "aemogie";
      userEmail = "54412618+aemogie@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "dev";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
      difftastic.enable = true;
    };
    gh = {
      enable = true;
      settings.version = 1; # nix-community/home-manager#4744
      settings.git_protocol = "ssh";
      gitCredentialHelper.hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
  };
}
