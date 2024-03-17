{
  pkgs,
  config,
  osConfig,
  ...
}: {
  imports = [../../../modules/discord];
  programs.discord = {
    enable = true;
    client = "webcord";
    style = let
      inherit (osConfig.paint.active.ctp) flavor accent;
      inherit (osConfig.paint.active.pal) base mantle crust;
      ctp = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        # NOTE: on the gh-pages branch
        rev = "9b7e9008c727cd056c20c82eae11471d22efe1e3";
        sha256 = "sha256-nZyNY4wOpMs2hPfn6ieUSfOqdPUf45VQm8+9mdUIGRg=";
      };
    in
      #css
      ''
        ${builtins.readFile "${ctp}/dist/catppuccin-${flavor}-${accent}.theme.css"}

        :root {
          --font-sans: ${config.fonts.sans}, sans-serif;
          --font-mono: ${config.fonts.monospace}, monospace;

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
        html.theme-light, html.theme-dark {
          /* 0xB2 = 0.7 * 0xFF */
          background: #${base}B2 !important;
          --background-primary: #${base}00 !important;
          --background-secondary: #${mantle}00 !important;
          --background-secondary-alt: #${mantle}00 !important;
          --background-tertiary: transparent !important;
          --channeltextarea-background: #${crust}00 !important;
          /* forum page uses this? */
          --home-background: transparent !important;
        }

        html.theme-light code.hljs, html.theme-dark code.hljs {
           background: #${base} !important;
        }

        div[class^="chat"] section[class*="forumOrHome_"],
        div[class^="chat"] > div[class^="content"] > div[class^="container"] div[class*="mainCard_"] {
          background: transparent !important;
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
