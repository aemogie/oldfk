{
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (osConfig.lib.paint.misc) replaceVars;
in {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    style = replaceVars osConfig.paint.active.pal (readFile ./style.css);
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe config.programs.waybar.package)];
  };
}
