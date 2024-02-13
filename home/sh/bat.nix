{pkgs, ...}: {
  paint.bat.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras) batgrep batman batpipe batwatch batdiff prettybat;
    };
  };
}
