{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = let
        navigation = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          g = "home";
          semicolon = "end";
          i = "pageup";
          u = "pagedown";
        };
        shiftSwap = {
          # doesnt work, keyd works with keys not charachters.
          # TODO: use xkb
          "_" = "-";
          "-" = "_";

          backslash = "|";
          "|" = "backslash";
        };
      in {
        main =
          {
            capslock = "overload(navigation, esc)";
            enter = "overload(navigation, enter)";

            numlock = "noop";
            esc = "noop";
            leftcontrol = "noop";
          }
          // (builtins.listToAttrs (map (k: {
            name = k;
            value = "noop";
          }) (builtins.attrValues navigation)));
        "navigation:C" = navigation;
      };
    };
  };
}
