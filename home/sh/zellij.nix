{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  autostart = false;
  inherit (osConfig.paint.active.pal) surface2 text red green primary blue yellow peach sky mantle pink;
in {
  imports = [../../modules/zellij.nix];
  home.shellAliases = {
    z = config.programs.zellij.baseCommand;
    e = config.programs.zellij.layouts.editor.command.new-session;
    phone = config.programs.zellij.layouts.phone.command.new-session;
    /*
    kq = "${let
      src = pkgs.fetchFromGitHub {
        owner = "Notarin";
        repo = "shuddle";
        rev = "a403da4cbc18d0db52e7c6006e529b7796ef032b";
        hash = "sha256-EBxrinQsRlo88sIB0OI2l5xMm1qjca/16+nZyg9n0V8=";
      };
      cargoToml = builtins.fromTOML (builtins.readFile (src + /Cargo.toml));
    in
      pkgs.rustPlatform.buildRustPackage {
        inherit (cargoToml.package) version;
        inherit src;
        pname = cargoToml.package.name;
        cargoLock.lockFile = src + /Cargo.lock;
      }}/bin/shuddle";
    */
  };
  programs.foot = lib.mkIf autostart {
    settings.main.shell = config.programs.zellij.baseCommand;
  };
  programs.zellij = {
    configs.default =
      #kdl
      ''
        keybinds clear-defaults=true {
          normal {
            bind "Alt N" { NewTab; }
            bind "Alt H" { GoToPreviousTab; }
            bind "Alt L" { GoToNextTab; }
            bind "Alt n" { NewPane; }
            bind "Alt q" { CloseFocus; }
            bind "Alt Q" { Quit; }
            bind "Alt h" { MoveFocus "Left"; }
            bind "Alt l" { MoveFocus "Right"; }
            bind "Alt j" { MoveFocus "Down"; }
            bind "Alt k" { MoveFocus "Up"; }
            bind "Alt f" { ToggleFocusFullscreen; }
            bind "Alt +" "Alt =" { Resize "Increase"; }
            bind "Alt -" "Alt _" { Resize "Decrease"; }
          }
        }


        themes {
            custom {
                bg "#${surface2}"
                fg "#${text}"
                red "#${red}"
                green "#${primary}" // "#${green}"
                blue "#${blue}"
                yellow "#${yellow}"
                magenta "#${pink}"
                orange "#${peach}"
                cyan "#${sky}"
                black "#${mantle}"
                white "#${text}"
            }
        }

        theme "custom"
      '';
    layouts = let
      tabbar =
        #kdl
        ''pane size=1 borderless=true { plugin location="zellij:compact-bar"; }'';
    in {
      default =
        #kdl
        ''
          layout {
            default_tab_template {
              ${tabbar}
              children
            }
            tab name="home" focus=true {
              pane name="shell"
            }
          }
        '';
      editor =
        #kdl
        ''
          layout {
            default_tab_template {
              ${tabbar}
              children
            }
            tab name="editor" {
              pane name="editor" borderless=true command="$EDITOR" { args "."; }
              pane name="terminal" size="50%"
            }
          }
          pane_borders false
        '';
      phone =
        #kdl
        ''
          layout {
            default_tab_template {
              ${tabbar}
              pane name="ssh into phone" command="${lib.getExe pkgs.openssh}" close_on_exit=true {
                args "phone";
              }
            }
          }
        '';
    };
  };
}
