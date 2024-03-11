{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) toUpper substring stringLength;
  caps = s: "${toUpper (substring 0 1 s)}${substring 1 (stringLength s) s}";
  dark_str =
    if _dark
    then "Dark"
    else "Light";
  inherit (config.paint.core) _ctp_flavor _ctp_accent _dark;
in {
  environment.systemPackages = [
    (pkgs.catppuccin-papirus-folders.override {
      accent = _ctp_accent;
      flavor = _ctp_flavor;
    })
    (pkgs.catppuccin-gtk.override {
      accents = [_ctp_accent];
      variant = _ctp_flavor;
    })
    pkgs.catppuccin-cursors."${_ctp_flavor}${dark_str}"
  ];
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path =
          if _dark
          then ../../assets/catppuccino-many.png
          else ../../assets/catppuccino-green.png;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = _dark;
        font_name = "Iosevka Aile 11";
        cursor_theme_name = "Catppuccin-${caps _ctp_flavor}-${dark_str}-Cursors";
        theme_name = "Catppuccin-${caps _ctp_flavor}-Standard-${caps _ctp_accent}-${dark_str}";
        icon_theme_name =
          "Papirus"
          + (
            if _dark
            then ""
            else "-Dark"
          );
      };
    };
  };
}
