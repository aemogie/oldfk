{
  inputs,
  pkgs,
  config,
  osConfig,
  ...
}: {
  imports = [
    # inferior to upstream hm's nix native config `settings`
    # inputs.hyprland.homeManagerModules.default
    ./keybinds.nix
    ./hyprpaper.nix
  ];
  home = {
    shellAliases.r = "${pkgs.hyprland}/bin/hyprctl dispatch exec";
    packages = [
      pkgs.hyprpicker
      (pkgs.writeShellScriptBin "scrcpy" ''
        export SDL_VIDEODRIVER=wayland
        args="\
          --turn-screen-off --stay-awake \
          --power-off-on-close \
          --display-buffer=200 --audio-buffer=200 --audio-output-buffer=20 \
        "
        pkill scrpy
        ${pkgs.hyprland}/bin/hyprctl dispatch exec "[workspace special;tile;no anim]" ${pkgs.scrcpy}/bin/scrcpy "$args"
      '')
    ];
    # sessionVariables.NIXOS_OZONE_WL = "1";
  };
  nixpkgs.overlays = [
    # { waybar = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland; }
    (_: _: {inherit (inputs.hyprland.packages.${pkgs.system}) hyprland;})
    # inputs.hyprland-contrib.overlays.default
  ];
  wayland.windowManager.hyprland = let
    opacity = "0.9";
    gaps_out = 20;
    border_size = 3;
  in {
    enable = true;
    settings = {
      # monitor = ",${toString mon.w}x${toString mon.h},0x0,1";
      monitor = ",preferred,auto,1";

      exec-once = ["${pkgs.hyprland}/bin/hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"];

      input = {
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };
      gestures.workspace_swipe = true;

      general = let
        inherit (osConfig.paint.active.pal) primary alternate crust;
      in {
        inherit gaps_out border_size;
        gaps_in = 10;
        # dont be fooled, these are all hex not dec
        "col.active_border" = "rgb(${primary}) rgb(${alternate}) 45deg";
        "col.inactive_border" = "rgba(${crust}FF)";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
      };

      dwindle = {
        preserve_split = true;
        smart_split = true;
      };

      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          size = 10;
          passes = 3;
          ignore_opacity = true;
          # popups = true;
          # popups_ignorealpha = 0;
          xray = true;
          special = true;
        };

        # inherit active_opacity inactive_opacity;
        # fullscreen_opacity = active_opacity;
      };

      windowrulev2 =
        [
          ''opacity ${opacity} override,class:jetbrains-idea-ce''
        ]
        # ++ (let
        #   x = mon.w * (1 - 0.3);
        #   y =
        #     (20 + 36) # TODO: load from waybar mdoule
        #     + gaps_out
        #     + border_size;
        #   w = mon.w - x - gaps_out - border_size;
        #   h = mon.h - y - gaps_out - border_size;
        # in [
        #   (rule {class = "WebCord";} "float")
        #   (rule {class = "WebCord";} "size ${toString w} ${toString h}")
        #   (rule {class = "WebCord";} "move ${toString x} ${toString y}")
        # ])
        ;
    };
  };
}
