{
  pkgs,
  config,
  ...
}: {
  programs.zathura = {
    enable = true;
    options.selection-notification = false;
    extraConfig = "include catppuccin-${config.paint.core._ctp_flavor}";
  };

  xdg.configFile."zathura" = {
    source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zathura";
        rev = "d85d8750acd0b0247aa10e0653998180391110a4";
        sha256 = "sha256-5Vh2bVabuBluVCJm9vfdnjnk32CtsK7wGIWM5+XnacM=";
      }
      + "/src";
    recursive = true;
  };
}
