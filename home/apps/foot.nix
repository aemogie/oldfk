{config, ...}: {
  programs.foot = {
    enable = true;
    # breaks with login script, idk why
    # - found out why. systemd sessionvariables are seperate from login ones. ofcourse they are
    server.enable = false;
    settings = {
      main = let
        font.name = config.fonts.monospace;
        font.size = 13;
        line-height = font.size * 1.75;
      in {
        font = "${font.name}:size=${toString font.size}";
        inherit line-height;
      };
      cursor.style = "beam";

      colors = let
        # TODO: replace with new module
        inherit (config.paint.core) base text surface2 subtext0 surface1 subtext1 red green yellow blue pink teal overlay0;
      in {
        alpha = "0.2";
        background = "${base}";
        foreground = "${text}";
        bright0 = "${surface2}";
        bright1 = "${red}";
        bright2 = "${green}";
        bright3 = "${yellow}";
        bright4 = "${blue}";
        bright5 = "${pink}";
        bright6 = "${teal}";
        bright7 = "${subtext0}";
        regular0 = "${surface1}";
        regular1 = "${red}";
        regular2 = "${green}";
        regular3 = "${yellow}";
        regular4 = "${blue}";
        regular5 = "${pink}";
        regular6 = "${teal}";
        regular7 = "${subtext1}";
      };
      /*
         this doesnt work.
      // listToAttrs (genList (i: {
          name = "dim${toString i}";
          value = "${overlay0}";
        })
        8);
      */
    };
  };
}
