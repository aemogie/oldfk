{
  config,
  lib,
  ...
}: let
  inherit (config.lib.paint.options) mkColorOption;
  inherit (config.lib.paint.types) rgbColor;
  inherit (lib) mkOption types;
  cfg = config.paint.core;
  alias = default:
    mkOption {
      inherit default;
      type = rgbColor;
    };
in {
  imports = [
    ../lib
    ../ctp_latte.nix
  ];
  options.paint.core = {
    _dark = mkOption {
      type = types.bool;
      default = true;
    };
    _ctp_flavor = mkOption {
      type = types.str;
      default = "mocha";
    };
    _ctp_accent = mkOption {
      type = types.str;
      default = "pink";
    };
    primary = alias cfg.${cfg._ctp_accent};
    alternate = alias cfg.mauve;
    success = alias cfg.green;
    warning = alias cfg.peach;
    error = alias cfg.red;

    rosewater = mkColorOption [245 224 220]; # f5e0dc    rgb(245, 224, 220)    hsl( 10, 56%, 91%)
    flamingo = mkColorOption [242 205 205]; #  f2cdcd    rgb(242, 205, 205)    hsl(  0, 59%, 88%)
    pink = mkColorOption [245 194 231]; #      f5c2e7    rgb(245, 194, 231)    hsl(316, 72%, 86%)
    mauve = mkColorOption [203 166 247]; #     cba6f7    rgb(203, 166, 247)    hsl(267, 84%, 81%)
    red = mkColorOption [243 139 168]; #       f38ba8    rgb(243, 139, 168)    hsl(343, 81%, 75%)
    maroon = mkColorOption [235 160 172]; #    eba0ac    rgb(235, 160, 172)    hsl(350, 65%, 77%)
    peach = mkColorOption [250 179 135]; #     fab387    rgb(250, 179, 135)    hsl( 23, 92%, 75%)
    yellow = mkColorOption [249 226 175]; #    f9e2af    rgb(249, 226, 175)    hsl( 41, 86%, 83%)
    green = mkColorOption [166 227 161]; #     a6e3a1    rgb(166, 227, 161)    hsl(115, 54%, 76%)
    teal = mkColorOption [148 226 213]; #      94e2d5    rgb(148, 226, 213)    hsl(170, 57%, 73%)
    sky = mkColorOption [137 220 235]; #       89dceb    rgb(137, 220, 235)    hsl(189, 71%, 73%)
    sapphire = mkColorOption [116 199 236]; #  74c7ec    rgb(116, 199, 236)    hsl(199, 76%, 69%)
    blue = mkColorOption [137 180 250]; #      89b4fa    rgb(137, 180, 250)    hsl(217, 92%, 76%)
    lavender = mkColorOption [180 190 254]; #  b4befe    rgb(180, 190, 254)    hsl(232, 97%, 85%)
    text = mkColorOption [205 214 244]; #      cdd6f4    rgb(205, 214, 244)    hsl(226, 64%, 88%)
    subtext1 = mkColorOption [186 194 222]; #  bac2de    rgb(186, 194, 222)    hsl(227, 35%, 80%)
    subtext0 = mkColorOption [166 173 200]; #  a6adc8    rgb(166, 173, 200)    hsl(228, 24%, 72%)
    overlay2 = mkColorOption [147 153 178]; #  9399b2    rgb(147, 153, 178)    hsl(228, 17%, 64%)
    overlay1 = mkColorOption [127 132 156]; #  7f849c    rgb(127, 132, 156)    hsl(230, 13%, 55%)
    overlay0 = mkColorOption [108 112 134]; #  6c7086    rgb(108, 112, 134)    hsl(231, 11%, 47%)
    surface2 = mkColorOption [88 91 112]; #    585b70    rgb( 88,  91, 112)    hsl(233, 12%, 39%)
    surface1 = mkColorOption [69 71 90]; #     45475a    rgb( 69,  71,  90)    hsl(234, 13%, 31%)
    surface0 = mkColorOption [49 50 68]; #     313244    rgb( 49,  50,  68)    hsl(237, 16%, 23%)
    base = mkColorOption [30 30 46]; #         1e1e2e    rgb( 30,  30,  46)    hsl(240, 21%, 15%)
    mantle = mkColorOption [24 24 37]; #       181825    rgb( 24,  24,  37)    hsl(240, 21%, 12%)
    crust = mkColorOption [17 17 27]; #        11111b    rgb( 17,  17,  27)    hsl(240, 23%,  9%)
  };
}
