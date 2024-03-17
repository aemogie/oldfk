{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) toUpper substring stringLength;
  caps = s: "${toUpper (substring 0 1 s)}${substring 1 (stringLength s) s}";
  dark_str =
    if useDark
    then "Dark"
    else "Light";
  inherit (config.paint.active.ctp) flavor accent;
  inherit (config.paint) useDark;
in {
  environment.systemPackages = [
    (pkgs.catppuccin-papirus-folders.override {
      accent = accent;
      flavor = flavor;
    })
    (pkgs.catppuccin-gtk.override {
      accents = [accent];
      variant = flavor;
    })
    pkgs.catppuccin-cursors."${flavor}${dark_str}"
  ];
  programs.regreet = {
    enable = true;
    cageArgs = ["-s" "-d"];
    settings = {
      background = {
        path =
          if useDark
          then ../../assets/catppuccino-many.png
          else ../../assets/catppuccino-green.png;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = useDark;
        font_name = "Iosevka Aile 11";
        cursor_theme_name = "Catppuccin-${caps flavor}-${dark_str}-Cursors";
        theme_name = "Catppuccin-${caps flavor}-Standard-${caps accent}-${dark_str}";
        icon_theme_name =
          "Papirus"
          + (
            if useDark
            then ""
            else "-Dark"
          );
      };
    };
  };
}
