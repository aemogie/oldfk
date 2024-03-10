{
  pkgs,
  lib,
  ...
}: let
  wallpaper = ../../../assets/cats.png;
  command = lib.getExe pkgs.hyprpaper;
in {
  wayland.windowManager.hyprland.settings.exec-once = [command];
  xdg.configFile."hypr/hyprpaper.conf" = {
    text = let
      inherit (lib.generators) toKeyValue mkKeyValueDefault mkValueStringDefault;
      inherit (lib.strings) concatStringsSep;
      inherit (builtins) isList isPath;
      mkValueString = v:
        if isNull v
        then ""
        else if isPath v
        then toString v
        else if isList v
        then concatStringsSep "," (map mkValueString v)
        else mkValueStringDefault {} v;
      simpleHyprLang = toKeyValue {mkKeyValue = mkKeyValueDefault {inherit mkValueString;} "=";};
    in
      simpleHyprLang {
        preload = wallpaper;
        wallpaper = [null wallpaper];
        splash = false;
        ipc = false;
      };
    onChange =
      #sh
      ''
        program='
          BEGIN { RS = "\0" ; FS = "=" }
          $1 == "HYPRLAND_INSTANCE_SIGNATURE" { print $2 }
        '
        for pid in $(${pkgs.procps}/bin/pgrep -f hyprpaper); do
          HYPRLAND_INSTANCE_SIGNATURE=$(${pkgs.gawk}/bin/gawk "$program" /proc/$pid/environ)
          kill $pid || true
          export HYPRLAND_INSTANCE_SIGNATURE
          ${pkgs.hyprland}/bin/hyprctl dispatch exec -- ${command} > /dev/null
        done
      '';
  };
}
