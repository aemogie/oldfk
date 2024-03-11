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
  home = {
    sessionVariables = {
      GTK_THEME = config.gtk.theme.name;
      GTK_USE_PORTAL = 1;
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors."${_ctp_flavor}${dark_str}";
      name = "Catppuccin-${caps _ctp_flavor}-${dark_str}-Cursors";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-${caps _ctp_flavor}-Standard-${caps _ctp_accent}-${dark_str}";
      package = pkgs.catppuccin-gtk.override {
        accents = [_ctp_accent];
        variant = _ctp_flavor;
      };
    };

    iconTheme = {
      name =
        "Papirus"
        + (
          if _dark
          then ""
          else "-Dark"
        );
      package = pkgs.catppuccin-papirus-folders.override {
        accent = _ctp_accent;
        flavor = _ctp_flavor;
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
      gtk-application-prefer-dark-theme =
        if _dark
        then 1
        else 0;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme =
        if _dark
        then 1
        else 0;
    };
  };
}
