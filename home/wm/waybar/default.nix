{
  config,
  lib,
  ...
}: let
  inherit (builtins) readFile mapAttrs;
  inherit (config.lib.paint.misc) replaceVars;
in {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    style = replaceVars config.paint.core (readFile ./style.css);
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe config.programs.waybar.package)];
  };
}
