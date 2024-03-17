{
  config,
  osConfig,
  ...
}: {
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
        inherit (osConfig.paint.active.pal) base text surface2 subtext0 surface1 subtext1 red green yellow blue pink teal;
        col = {
          alpha = "0.7";
          background = "${base}";
          foreground = "${text}";
          bright0 = "${surface2}"; # gray
          bright1 = "${red}"; #      red
          bright2 = "${green}"; #    green
          bright3 = "${yellow}"; #   yellow
          bright4 = "${blue}"; #     blue
          bright5 = "${pink}"; #     magenta
          bright6 = "${teal}"; #     cyan
          bright7 = "${subtext0}"; # white
          regular0 = "${surface1}";
          regular1 = "${red}";
          regular2 = "${green}";
          regular3 = "${yellow}";
          regular4 = "${blue}";
          regular5 = "${pink}";
          regular6 = "${teal}";
          regular7 = "${subtext1}";
        };
      in
        if (!osConfig.paint.useDark)
        then
          col
          // {
            bright0 = col.bright7;
            bright7 = col.bright0;
            regular0 = col.regular7;
            regular7 = col.regular0;
          }
        else col;
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
