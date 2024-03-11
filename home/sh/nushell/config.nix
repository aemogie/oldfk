{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nushell.extraConfig =
    ( #nu
      ''
         use std *

         # Convert structured data to a Nix expression.
         def "to nix" []: any -> string {
           to json
           | nix eval --expr $"builtins.fromJSON \'\'($in)\'\'"
           | ${lib.getExe pkgs.alejandra} -q
         };

         # Convert from Nix expression to structured data.
         def "from nix" []: string -> any {
           let expr = $in;
           do -i { nix eval --json --expr $expr } | complete | if $in.exit_code == 0 {
             $in.stdout | from json
           } else {
             error make { msg: $in.stderr }
           }
         }

         # Open a file. Show structured data, if possible. Else fallback to `bat`
         def o [filename: path] {
           try { open $filename } catch { open --raw $filename }
           | if ($in | describe) == "string" {
             highlight ($filename | path parse).extension -t ansi | ${pkgs.less}/bin/less -F
           } else { $in }
         }

         # If multiple shells are open, exit current one. If this is the last one, exit completely.
         def --env q [] {
           if (shells | length) == 1 { exit } else { dexit }
         }

        def --env md [name: directory] {
          mkdir $name
          enter $name
        }

        def --wrapped r [
          program: string,
          ...args: string,
          --no-expand (-n), # Relative paths don't work with the `exec` dispatcher. Enable this flag to disable path expansion.
        ] {
          let p = (which -a $program)
          if (not ($p | is-empty)) and ("external" in $p.type) {
            if ($no_expand) {
              hyprctl dispatch exec $"($program) ($args | str join ' ')" | ignore
            } else {
              let args = ($args | each {
                if ($in | path exists) {
                  $in | path expand
                } else { $in }
              })
              hyprctl dispatch exec $"($program) ($args | str join ' ')" | ignore
            }
          } else {
            error make {
              msg: "program not found",
              label: {
                text: $"could not found program `($program)`!",
                span: (metadata $program).span
              }
            }
          }
        }

        def e [cwd: path = .] {
          cd ($cwd | path expand)
          if ZELLIJ in $env {
            ${config.programs.zellij.layouts.editor.command.new-tab}
          } else {
            ${config.programs.zellij.layouts.editor.command.new-session}
          }
        }

         # Translate text using Google Translate
         def tl [
           text: string, # The text to translate
           --source(-s): string = "auto", # The source language
           --destination(-d): string = "en", # The destination language
           --list(-l)  # Select destination language from list
         ] {

           let dest = if $list {
             let languages = open ${./languages.json};
             let selection = (
               $languages
               | columns
               | input list -f "Select destination language:"
             )
             $languages | get $selection
           } else {
             $destination
           };

           return ({
             scheme: "https",
             host: "translate.googleapis.com",
             path: "/translate_a/single",
             params: {
                 client: gtx,
                 sl: $source,
                 tl: $dest,
                 dt: t,
                 q: ($text | url encode),
             }
           }
           | url join
           | http get $in
           | get 0.0.0
           )
        }

        def todo [msg: string = "to be implemented"] {
          let span = (metadata $msg).span
          error make {
            msg: $msg
            label: {
              text: "right here"
              start: $span.start
              end: $span.end
            }
          }
        }
      ''
    )
    + (let
      inherit (builtins) mapAttrs toJSON attrValues attrNames replaceStrings isAttrs filter;
      previewStr = "preview";
      buildColour = hex: colour @ {
        name,
        r,
        g,
        b,
        ...
      }:
        {
          inherit name;
          ${previewStr} =
            "\\u{001b}[48;2;"
            + "${toString r};${toString g};${toString b}m"
            + lib.fixedWidthString (builtins.stringLength previewStr) " " ""
            + "\\u{001b}[0m";
        }
        // (
          if hex
          then {hex = "${colour}";}
          else {inherit r g b;}
        );
      toJsonNoEscape = x: replaceStrings ["\\\\"] ["\\"] (toJSON x);
      pal = filter (v: v != null) (attrValues (mapAttrs (name: v:
        if isAttrs v
        then v // {inherit name;}
        else null)
      config.paint.core));
      palRgb = toJsonNoEscape (map (buildColour false) pal);
      palHex = toJsonNoEscape (map (buildColour true) pal);
    in
      #nu
      ''
        ;
        # View the system colour palette
        def pal [
          colour?: string
          --all(-a) # View all the colours, instead of just one
          --hex(-h) # View the colours as hex colour codes
        ] {
          const pal_rgb = ${palRgb};
          const pal_hex = ${palHex};
          let $pal = if $hex { $pal_hex } else { $pal_rgb };

          if $all {
            return $pal
          } else {
            let col = if ($colour == null) {
              $pal | input list -f
            } else if ($colour in ${toJSON (map (v: v.name) pal)}) {
              $pal | where name == $colour | first
            } else {
              let span = (metadata $colour).span;
              error make {
                msg: "invalid colour name",
                label: {
                  text: "colour provided here",
                  start: $span.start,
                  end: $span.end,
                }
              }
            };
            if $hex { $col } else { $col }
          }
        }
      '');
}
