{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings.windowrulev2 =
    [
      ''opacity 1 override,class:firefox,title:^(.*\[.*\b(youtube\.com|twitch\.tv)\] — Mozilla Firefox)''
      ''opacity 0.9 override,class:firefox,title:^(?!.*\[.*\b(youtube\.com|twitch\.tv)\] — Mozilla Firefox)''
    ]
    /*
    ++ (let
      hCfg = config.wayland.windowManager.hyprland.settings;
      inherit (hCfg.general) gaps_out;
    in [
      ''float,class:firefox,title:^(Picture-in-Picture)''
      ''move 100%-${toString gaps_out} 100%-${toString gaps_out},class:firefox,title:^(Picture-in-Picture)''
      ''pin,class:firefox,title:^(Picture-in-Picture)''
      ''nofocus,class:firefox,title:^(Picture-in-Picture)''
    ])
    */
    ;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    /*
    package = pkgs.firefox.override {
      extraPrefs =
        #js github:MrOtherGuy/fx-autoconfig
        ''
          try {
            let cmanifest = Cc['@mozilla.org/file/directory_service;1'].getService(Ci.nsIProperties).get('UChrm', Ci.nsIFile);
            cmanifest.append('utils');
            cmanifest.append('chrome.manifest');

            if (cmanifest.exists()){
              Components.manager.QueryInterface(Ci.nsIComponentRegistrar).autoRegister(cmanifest);
              ChromeUtils.importESModule('chrome://userscript/content/boot.sys.mjs');
            }
          } catch(ex) {};
        '';
    };
    */
    profiles.old.id = 0;
    profiles.new.id = 2;
    profiles.default = {
      id = 1;
      settings = let
        inherit (config.paint.core) base text primary alternate;
      in {
        "browser.download.useDownloadDir" = true;
        "browser.display.foreground_color" = "#${text}";
        "browser.display.background_color" = "#${base}";
        "devtools.chrome.enabled" = true;
        "full-screen-api.ignore-widgets" = true;
      };
      extraConfig = let
        _ =
          #js https://gist.github.com/jscher2000/ad268422c3187dbcbc0d15216a3a8060
          ''
            var ss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(Ci.nsIStyleSheetService);

            var dir = Services.dirsvc.get("UChrm", Ci.nsIFile);

            var chrome = dir.clone();chrome.append("userChrome.css");
            chrome = Services.io.newFileURI(chrome);

            var content = dir.clone();content.append("userContent.css");
            content = Services.io.newFileURI(content);

            setInterval(() => {
              // Unregister the sheet
              if (ss.sheetRegistered(chrome, ss.USER_SHEET)) {
                ss.unregisterSheet(chrome, ss.USER_SHEET);
              }
              ss.loadAndRegisterSheet(chrome, ss.USER_SHEET);

              if (ss.sheetRegistered(content, ss.USER_SHEET)) {
                ss.unregisterSheet(content, ss.USER_SHEET);
              }
              ss.loadAndRegisterSheet(content, ss.USER_SHEET);
            }, 1000);
          '';
      in "";
    };
  };
}
