{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./config.nix ../../../modules/nushell.nix];
  home = {
    # the benefit of doing it as a nixos module instead of standalone.
    loginShell = config.programs.nushell.package;
    packages = [
      pkgs.wl-clipboard # wl-copy/wl-paste
      pkgs.libnotify # notify-send
    ];
  };
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;
    config = {
      show_banner = false;
      rm.always_trash = true;
      table.index_mode = "auto";
      history = {
        file_format = "sqlite";
        isolation = true;
      };
      shell_integration = false;
      use_kitty_protocol = false;
    };
    extraConfig = let
      inherit (config.paint.core) _ctp_flavor _dark;
      nu_scripts = pkgs.fetchFromGitHub {
        owner = "nushell";
        repo = "nu_scripts";
        rev = "4fe113714aab5a2437cc2ab1d83588a2c5c458a7";
        sha256 = "sha256-D9WSTLWKU7lBMjIgTFECb+WokBYxGlzJ7tdZN8+2bpc=";
      };
      theme_name =
        if _ctp_flavor == "mocha"
        then "catppuccin-mocha"
        else if _dark
        then "nushelll-dark"
        else "nushell-light";
    in
      #nu color scheme
      ''
        $env.config = ($env.config | merge {
          color_config: (if true {
            use ${nu_scripts}/themes/themes/${theme_name}.nu
            ${theme_name}
          })
        })
      '';
    shellAliases = builtins.removeAttrs config.home.shellAliases ["o" "q" "r" "e"]; # are nu functions instead

    # manage the file
    envFile.text = "";
    loadSessionVariables = true;
    plugins =
      [
        "${pkgs.nushellPlugins.query}/bin/nu_plugin_query"
      ]
      ++ (let
        _ = [
          # TODO: move to /pkgs/nu_plugins/...
          "${pkgs.rustPlatform.buildRustPackage rec {
            pname = "nu_plugin_kdl";
            version = pkgs.nushell.version;
            src = pkgs.fetchFromGitHub {
              owner = "amtoine";
              repo = pname;
              rev = "36e363004a7b02b00c3e701385641479f17a49d3";
              sha256 = "sha256-/pr75+c0s1SSZ/MJUpVOPb/qUgyWUtchU2J/p5/wTec=";
            };
            cargoLock.lockFile = ./plugins/kdl.lock;
            patches = [./plugins/kdl.patch];
            postPatch = ''
              ${lib.getExe pkgs.nushell} ./cargo-setup.nu ${pkgs.nushell.src}
              ln -sf ${cargoLock.lockFile} Cargo.lock
            '';
          }}/bin/nu_plugin_kdl"
          "${pkgs.rustPlatform.buildRustPackage rec {
            pname = "nu-plugin-highlight";
            version = "1.0.7";
            src = pkgs.fetchFromGitHub {
              owner = "cptpiepmatz";
              repo = pname;
              rev = "v${version}";
              sha256 = "sha256-mOmVOPBWENCloA9HcORVSm/dAv6OT/EsIJZ2xVA6MhI=";
            };
            cargoLock.lockFile = ./plugins/highlight.lock;
            postPatch = ''
              substituteInPlace Cargo.toml \
                --replace ../nushell ${pkgs.nushell.src} \
                --replace 0.86 ${pkgs.nushell.version}
              ln -sf ${cargoLock.lockFile} Cargo.lock
            '';
          }}/bin/nu_plugin_highlight"
        ];
      in []);
  };
}
