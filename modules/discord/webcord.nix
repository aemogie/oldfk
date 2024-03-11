{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) toFile toJSON;
  inherit (lib) mkOption mkPackageOption mkIf mkDefault hm concatMapStrings;
  inherit (lib.types) attrs listOf either package path;
  cfg = config.programs.discord;
in {
  options.programs.discord.webcord = {
    package = mkPackageOption pkgs ["webcord"] {};
    config = mkOption {
      type = attrs;
      description = "Configuration for WebCord (if it is selected).";
      default = {
        screenShareStore.audio = false;
        settings = {
          advanced = {
            csp.enabled = true;
            cspThirdParty = {
              algolia = true;
              audius = true;
              gif = true;
              googleStorageApi = true;
              hcaptcha = true;
              paypal = true;
              reddit = true;
              soundcloud = true;
              spotify = true;
              streamable = true;
              twitch = true;
              twitter = true;
              vimeo = true;
              youtube = true;
            };
            currentInstance.radio = 0;
            devel.enabled = false;
            optimize.gpu = false;
            redirection.warn = true;
            unix.autoscroll = false;
            webApi.webGl = true;
          };
          general = {
            menuBar.hide = false;
            taskbar.flash = true;
            tray.disable = false;
            window = {
              hideOnClose = true;
              transparent = false;
            };
          };
          privacy = {
            blockApi = {
              fingerprinting = true;
              science = true;
              typingIndicator = false;
            };
            permissions = {
              audio = null;
              background-sync = false;
              display-capture = true;
              fullscreen = true;
              notifications = null;
              video = null;
            };
          };
        };

        update.notification = {
          till = "";
          version = "";
        };
      };
    };
    extensions = mkOption {
      type = listOf (either package path);
      default = [];
      description = ''
        List of Chrome extensions to load to WebCord.
      '';
    };
  };
  config = mkIf (cfg.enable && cfg.client == "webcord") {
    programs.discord.launch_command = mkDefault "${cfg.webcord.package}/bin/webcord";
    xdg.configFile."WebCord/Themes/custom".text = cfg.style;
    home.activation.webcordConfig = let
      inherit (config.xdg) configHome;
      configSetup =
        ""
        + #bash
        ''
          [ -d "$(dirname "${configHome}/WebCord")" ] && \
          cp -f ${toFile "webcord-config.json" (toJSON cfg.webcord.config)} ${configHome}/WebCord/ && \
        ''
        + #bash webcord needs write perms or it wont start
        ''
          chmod +w ${configHome}/WebCord/config.json
        '';
      extensionsSetup =
        ""
        + #bash
        ''
          [ -d "$(dirname "${configHome}/WebCord")" ] && \
          mkdir -p ${configHome}/WebCord/Extensions/Chrome/ && \
        ''
        # copy all extensions
        + concatMapStrings (ext: "cp -frT ${ext} ${configHome}/WebCord/Extensions/Chrome/${ext.name} && \\\n") cfg.webcord.extensions
        + #bash webcord wont load it without write perms
        ''
          chmod -R +w ${configHome}/WebCord/Extensions
        '';
    in
      hm.dag.entryAfter ["writeBoundary"] (configSetup + "\n" + extensionsSetup);
    home.packages = [cfg.webcord.package];
  };
}
