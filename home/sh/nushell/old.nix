{
  osConfig,
  pkgs,
  ...
}: {
  imports = [./config.nix ../../../modules/nushell.nix];
  home = {
    # the benefit of doing it as a nixos module instead of standalone.
    loginShell = config.programs.nushell.package;
    packages = [
      pkgs.wl-clipboard # wl-copy/wl-paste
      pkgs.xdg-utils # xdg-open
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
      shell_integration = true;
      use_kitty_protocol = true;
    };
    extraConfig = let
      inherit (osConfig.paint.core) _ctp_flavor;
    in
      #nu color scheme
      ''
        $env.config = ($env.config | merge {
          color_config: (if true {
            use ${pkgs.fetchFromGitHub {
            owner = "nushell";
            repo = "nu_scripts";
            rev = "4fe113714aab5a2437cc2ab1d83588a2c5c458a7";
            sha256 = "sha256-D9WSTLWKU7lBMjIgTFECb+WokBYxGlzJ7tdZN8+2bpc=";
          }
          + "/themes/themes/catppuccin-${_ctp_flavor}.nu"}
            catppuccin-${_ctp_flavor}
          })
        })
      '';
    shellAliases = builtins.removeAttrs config.home.shellAliases ["o" "q" "fk" "e"]; # are nu functions instead

    # manage the file
    envFile.text = "";
    loadSessionVariables = true;
    # move to module
    # loginFile.text = let
    #   source = pkgs.runCommandLocal "expand-env.nu" {} ''
    #     source "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
    #     cat <<EOF > $out
    #     if $env.__HM_SESS_VARS_SOURCED != "1" {
    #     ${lib.escape ["$"] #nu

    #       ''
    #         def __login_hm_var_new_value [key: string, value: string] {
    #           if $key in $env {
    #             # if it already exists, see if replacement is possible
    #             let old = ($env | get $key)
    #             let newVal = match ($old | describe) {
    #               "string" => {
    #                 let oldSplit = ($old | split row (char esep))
    #                 if ($oldSplit | length) <= 1 {
    #                   $value # override
    #                 } else {
    #                   let newSplit = ($value | split row (char esep))
    #                   $oldSplit | prepend $newSplit | uniq | str join (char esep)
    #                 }
    #               },
    #               "list<string>" => ($old | prepend ($value | split row (char esep)) | uniq),
    #             }
    #             $newVal
    #           } else {
    #             $value
    #           }
    #         }
    #       ''}
    #     ${builtins.concatStringsSep "\n" (
    #       map (key: "\\$env.${key} = (__login_hm_var_new_value \"${key}\" \"\$${key}\")")
    #       ((builtins.attrNames config.home.sessionVariables) ++ ["PATH"])
    #     )}
    #     } # end if
    #     EOF
    #   '';
    #   env = "${pkgs.coreutils}/bin/env";
    #   bash = lib.getExe pkgs.bash;
    # in
    #   #nu
    #   ''
    #     # USER is set cause --ignore-environment breaks it
    #     do {
    #       ${env} --ignore-environment USER=${config.home.username} ${bash} --login -c ${env}
    #       | tee ${config.xdg.cacheHome}/.env
    #     }
    #     | complete | get stdout
    #     | lines
    #     | reduce -f {} {|it, acc|
    #         let kv = ($it | split row = -n 2);
    #         # _, PWD and SHLVL are bash builtins. idk where TERM=dumb sneaked in, but thats a thing too
    #         if not ($kv.0 in [TERM _ PWD SHLVL]) {
    #           $acc | merge {$kv.0: $kv.1}
    #         } else {$acc}
    #       }
    #     | load-env
    #   '';
  };
}
