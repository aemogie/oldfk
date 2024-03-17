{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) toUpper substring stringLength;
  caps = s: "${toUpper (substring 0 1 s)}${substring 1 (stringLength s) s}";
  inherit (osConfig.paint) useDark;
  inherit (osConfig.paint.active.ctp) flavor accent;
  dark_str =
    if useDark
    then "dark"
    else "light";
in {
  home = {
    sessionVariables = {
      GTK_THEME = config.gtk.theme.name;
      GTK_USE_PORTAL = 1;
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors."${flavor}${caps dark_str}";
      name = "Catppuccin-${caps flavor}-${caps dark_str}-Cursors";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-${dark_str}";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-${caps flavor}-Standard-${caps accent}-${caps dark_str}";
      package = pkgs.catppuccin-gtk.override {
        accents = [accent];
        variant = flavor;
      };
    };

    iconTheme = {
      name =
        "Papirus"
        + (
          if useDark
          then ""
          else "-Dark"
        );
      package = pkgs.catppuccin-papirus-folders.override {
        accent = accent;
        flavor = flavor;
      };
    };

    font = {
      name = config.fonts.sans;
      size = 11;
    };

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = useDark;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = useDark;
    };
  };
}
