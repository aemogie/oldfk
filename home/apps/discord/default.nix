{
  pkgs,
  config,
  ...
}: {
  imports = [../../../modules/discord];
  programs.discord = {
    enable = true;
    client = "webcord";
    style = let
      inherit (config.paint.core) _ctp_flavor _ctp_accent base mantle crust surface0;
      ctp = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        # NOTE: on the gh-pages branch
        rev = "caaea219ddf5bb5428e87fe65be9034db6f05998";
        sha256 = "sha256-/QUa7YN/AdYUxrqgaD2rC4nbo1cR/1oHYFVcFpNTGzI=";
      };
    in
      #css
      ''
        ${builtins.readFile "${ctp}/dist/catppuccin-${_ctp_flavor}-${_ctp_accent}.theme.css"}

        :root {
          --font-sans: "${config.fonts.sans}", sans-serif;
          --font-mono: "${config.fonts.monospace}", monospace;

          --font-primary: var(--font-sans);
          --font-headline: var(--font-sans);
          --font-display: var(--font-sans);
          --font-code: var(--font-mono);
        }

        /* remove chatbox gift, gif, sticker and emoji icons. */
        :has(>.expression-picker-chat-input-button) {
            display: none;
        }

        code {
          font-stretch: expanded;
        }
        [class^="messageContent"], [class*=" messageContent"] {
          font-size: 95% !important;
          letter-spacing: -0.25px;
        }

        /* most of it happens here */
        .theme-light, .theme-dark {
          --background-primary: #${base}80 !important;
          --background-secondary: #${mantle}80 !important;
          --background-secondary-alt: #${mantle}80 !important;
          --channeltextarea-background: #${crust}80 !important;

          /* this is behind all other elements. keep it transparent so that other colours work */
          --background-tertiary: transparent !important;
        }

        /* uses bg-tertiary which is transparent now, so switch it out */
        [aria-label="Servers sidebar"] {
            background-color: var(--background-secondary-alt) !important;
        }
        .theme-light code.hljs, .theme-dark code.hljs {
           /* since it's just .25 the difference is little on dark bgs.
              but .5 adds up w bg .5 and no transperency then */
           background: #${base}80 !important;
        }

        /* fixes for forum channels */
        div[class|="chat"] > div[class|="content"] > div[class|="container"] {
          background-color: #${base}80 !important;
        }
        div[class|="chat"] > div[class|="content"] > div[class|="container"] div[class*="mainCard-"] {
          background-color: #${surface0}80 !important;
        }

        div[class^=chatContainer]>div[class^=container] {
          background-color: unset;
        }

        div.container__4bde3 {
          backdrop-filter: blur(10px);
        }
      '';

    openasar.config.openasar = {
      setup = true;
      quickstart = true;
      cmdPreset = "battery";
    };

    webcord = {
      package = pkgs.webcord;
      config = {
        settings = {
          general = {
            menuBar.hide = true;
            window.transparent = true;
          };
          privacy.permissions = {
            background-sync = true;
            notifications = true;
          };
        };
      };
      extensions = [
        (
          pkgs.runCommand "webcord_disable_menu_bar" {} ''
            mkdir $out
            cat <<EOF > $out/manifest.json
            ${builtins.toJSON {
              content_scripts = [
                {
                  js = ["disable_menu_bar.js"];
                  matches = ["<all_urls>"];
                }
              ];
              manifest_version = 3;
              name = "Disable Menu Bar";
              version = "0.1.0";
            }}
            EOF

            cat <<EOF > $out/disable_menu_bar.js
            ${ #js
              ''
                document.addEventListener('keyup', e => { if (e.key == "Alt" || e.key == "Meta") e.preventDefault(); });
              ''
            }
            EOF
          ''
        )
      ];
    };
  };
}
