{
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (osConfig.paint.active.pal) base rosewater green text lavender peach blue maroon;
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings =
      {
        color = "${base}";
        bs-hl-color = "${rosewater}";
        caps-lock-bs-hl-color = "${rosewater}";
        caps-lock-key-hl-color = "${green}";
        key-hl-color = "${green}";
        layout-text-color = "${text}";
        ring-color = "${lavender}";
        ring-clear-color = "${rosewater}";
        ring-caps-lock-color = "${peach}";
        ring-ver-color = "${blue}";
        text-color = "${text}";
        text-clear-color = "${rosewater}";
        text-caps-lock-color = "${peach}";
        text-ver-color = "${blue}";
        text-wrong-color = "${maroon}";
        ring-wrong-color = "${maroon}";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        separator-color = "00000000";
      }
      // {
        font = config.fonts.sans;
        # image = toString ../../assets/street.png;
        indicator = true;
        clock = true;
      };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
  };
}
