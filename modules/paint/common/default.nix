{
  config,
  lib,
  ...
}: let
  inherit (config.lib.paint.options) mkColorOption;
  inherit (config.lib.paint.types) rgbColor;
  inherit (lib) mkOption types;
  alias = default:
    mkOption {
      inherit default;
      type = rgbColor;
    };
in {
  imports = [../lib];
  options.paint = {
    useDark = mkOption {
      type = types.bool;
      default = true;
    };
    active = mkOption {
      type = types.attrs;
      default =
        if config.paint.useDark
        then config.paint.dark
        else config.paint.light;
    };
    dark = let
      cfg = config.paint.dark;
    in {
      ctp = {
        flavor = mkOption {
          type = types.str;
          default = "mocha";
        };
        accent = mkOption {
          type = types.str;
          default = "pink";
        };
      };
      pal = {
        primary = alias cfg.pal.${cfg.ctp.accent};
        alternate = alias cfg.pal.mauve;
        success = alias cfg.pal.green;
        warning = alias cfg.pal.peach;
        error = alias cfg.pal.red;

        rosewater = mkColorOption "f5e0dc";
        flamingo = mkColorOption "f2cdcd";
        pink = mkColorOption "f5c2e7";
        mauve = mkColorOption "cba6f7";
        red = mkColorOption "f38ba8";
        maroon = mkColorOption "eba0ac";
        peach = mkColorOption "fab387";
        yellow = mkColorOption "f9e2af";
        green = mkColorOption "a6e3a1";
        teal = mkColorOption "94e2d5";
        sky = mkColorOption "89dceb";
        sapphire = mkColorOption "74c7ec";
        blue = mkColorOption "89b4fa";
        lavender = mkColorOption "b4befe";
        text = mkColorOption "cdd6f4";
        subtext1 = mkColorOption "bac2de";
        subtext0 = mkColorOption "a6adc8";
        overlay2 = mkColorOption "9399b2";
        overlay1 = mkColorOption "7f849c";
        overlay0 = mkColorOption "6c7086";
        surface2 = mkColorOption "585b70";
        surface1 = mkColorOption "45475a";
        surface0 = mkColorOption "313244";
        base = mkColorOption "1e1e2e";
        mantle = mkColorOption "181825";
        crust = mkColorOption "11111b";
      };
    };
    light = let
      cfg = config.paint.light;
    in {
      ctp = {
        flavor = mkOption {
          type = types.str;
          default = "latte";
        };
        accent = mkOption {
          type = types.str;
          default = "pink";
        };
      };
      pal = {
        primary = alias cfg.pal.${cfg.ctp.accent};
        alternate = alias cfg.pal.mauve;
        success = alias cfg.pal.green;
        warning = alias cfg.pal.peach;
        error = alias cfg.pal.red;

        rosewater = mkColorOption "dc8a78";
        flamingo = mkColorOption "dd7878";
        pink = mkColorOption "ea76cb";
        mauve = mkColorOption "8839ef";
        red = mkColorOption "d20f39";
        maroon = mkColorOption "e64553";
        peach = mkColorOption "fe640b";
        yellow = mkColorOption "df8e1d";
        green = mkColorOption "40a02b";
        teal = mkColorOption "179299";
        sky = mkColorOption "04a5e5";
        sapphire = mkColorOption "209fb5";
        blue = mkColorOption "1e66f5";
        lavender = mkColorOption "7287fd";
        text = mkColorOption "4c4f69";
        subtext1 = mkColorOption "5c5f77";
        subtext0 = mkColorOption "6c6f85";
        overlay2 = mkColorOption "7c7f93";
        overlay1 = mkColorOption "8c8fa1";
        overlay0 = mkColorOption "9ca0b0";
        surface2 = mkColorOption "acb0be";
        surface1 = mkColorOption "bcc0cc";
        surface0 = mkColorOption "ccd0da";
        base = mkColorOption "eff1f5";
        mantle = mkColorOption "e6e9ef";
        crust = mkColorOption "dce0e8";
      };
    };
  };
  config.specialisation = {
    dark.configuration.paint.useDark = true;
    light.configuration.paint.useDark = false;
  };
}
