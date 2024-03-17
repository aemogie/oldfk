{
  osConfig,
  config,
  ...
}: let
  inherit (osConfig.paint.active.pal) base text primary alternate;
in {
  services.mako = {
    enable = true;
    backgroundColor = "#${base}80";
    textColor = "#${text}FF";
    progressColor = "source #${alternate}80";
    font = "${config.fonts.sans} 12";
    borderRadius = 5;
    borderColor = "#${primary}FF";
    borderSize = 2;
    padding = "10";
    margin = "10";
    extraConfig = "outer-margin=20"; # from hyprland config. move to global option
    defaultTimeout = 5000;
  };
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur,^notifications$"
    "ignorealpha 0.5,^notifications$"
  ];
}
