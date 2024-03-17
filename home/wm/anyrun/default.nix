{
  pkgs,
  inputs,
  osConfig,
  config,
  ...
}: let
  bgalpha = 0.6; # make into module option
  inherit (osConfig.paint.active.pal) base crust text primary;
  cssRgba = {
    r,
    g,
    b,
    ...
  }: alpha: "rgba(${toString r},${toString g},${toString b},${toString alpha})";
in {
  imports = [inputs.anyrun.homeManagerModules.default];

  programs.anyrun = {
    enable = true;

    config = {
      plugins = with (inputs.anyrun.packages.${pkgs.system}); [
        applications
        rink
        shell
        translate
        websearch
      ];

      # width.fraction = 0.4;
      y.fraction = 0.2;
      hidePluginInfo = true;
      closeOnClick = true;
      maxEntries = 10;
      showResultsImmediately = true;
    };

    extraCss =
      #css (from github:n3oney/nixus)
      ''
        window {
          background: transparent; /* rgba(0, 0, 0, 0.8);*/
        }

        * {
          transition: 200ms ease;
          font-family: ${config.fonts.sans}; /* use some system font config */
        }

        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        #match.activatable {
          padding: 12px 14px;
          border-radius: 12px;

          color: #${text};
          margin-top: 4px;
          border: 2px solid transparent;
          transition: all 0.3s ease;
        }

        #match.activatable:not(:first-child) {
          border-top-left-radius: 0;
          border-top-right-radius: 0;
          border-top: 2px solid ${cssRgba text 0.1};
        }

        #match.activatable #match-title {
          font-size: 1.3rem;
        }

        #match.activatable:hover {
          border: 2px solid ${cssRgba text 0.4};
        }

        #match-title, #match-desc {
          color: inherit;
        }

        #match.activatable:hover, #match.activatable:selected {
          border-top-left-radius: 12px;
          border-top-right-radius: 12px;
        }

        #match.activatable:selected + #match.activatable, #match.activatable:hover + #match.activatable {
          border-top: 2px solid transparent;
        }

        #match.activatable:selected, #match.activatable:hover:selected {
          background: ${cssRgba text 0.1};
          border: 2px solid ${cssRgba primary bgalpha};
        }

        #match, #plugin {
          box-shadow: none;
        }

        #entry {
          color: #${text};
          box-shadow: none;
          border-radius: 12px;
          border: 2px solid ${cssRgba primary bgalpha};
        }

        box#main {
          background: ${cssRgba base bgalpha};
          border-radius: 16px;
          padding: 8px;
          box-shadow: 0px 2px 33px -5px ${cssRgba crust 0.5};
        }

        row:first-child {
          margin-top: 6px;
        }
      '';

    extraConfigFiles."shell.ron".text =
      #ron
      ''Config(prefix: ">")'';
  };
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur,^anyrun$"
    "ignorealpha ${toString (bgalpha - 0.1)},^anyrun$"
  ];
}
