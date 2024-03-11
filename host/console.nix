{config, ...}: {
  console.colors = let
    inherit (config.paint.core) base text surface2 subtext0 surface1 subtext1 red green yellow blue pink teal overlay0;
    _ = [
      "1e1e2e" # base      # bg_default, black
      "585b70" # surface2  # red

      "bac2de" # subtext1  # green
      "a6adc8" # subtext0  # yellow

      "f38ba8" # red       # blue,
      "f38ba8" #           # magenta

      "a6e3a1" # green     # cyan, underline
      "a6e3a1" #           # white, default

      "f9e2af" # yellow    # dimmed
      "f9e2af" #           # bold (black, red)

      "89b4fa" # blue      #
      "89b4fa" #           # bold (green, yellow)

      "f5c2e7" # pink      #
      "f5c2e7" #           # bold (blue, magenta)

      "94e2d5" # teal      #
      "94e2d5" #           # bold (cyan, white)
    ];
  in
    map toString [
      base #   black, blackground
      red #    red
      green #  green
      yellow # yellow
      blue #   blue,
      pink #   magenta
      teal #   cyan
      text #   white, text

      # bold
      base #   black, blackground
      red #    red
      green #  green
      yellow # yellow
      blue #   blue,
      pink #   magenta
      teal #   cyan
      text #   white, text
    ];
}
