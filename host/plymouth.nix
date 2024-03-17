{
  pkgs,
  config,
  ...
}: {
  boot.plymouth = {
    enable = true;
    theme = "catppuccin-${config.paint.active.ctp.flavor}";
    themePackages = [
      (pkgs.stdenv.mkDerivation {
        name = "catppuccin-plymouth";

        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "plymouth";
          rev = "67759fbe15eb9490d096ef8014d9f92fc5748fe7";
          sha256 = "sha256-IzoyVOi44Uay7DTfzR9RdRLSjORsdBM4pPrgeXk5YMI=";
        };

        # github:nekowinston/nur
        installPhase = ''
          mkdir -p "$out/share/plymouth/themes/"
          cp -r "themes/"* "$out/share/plymouth/themes/"

          themes=("mocha" "macchiato" "frappe" "latte")
          for dir in "''${themes[@]}"; do
            cat "themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth" | sed "s@\/usr\/@''${out}\/@" > "''${out}/share/plymouth/themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth"
          done
        '';
      })
    ];
  };
}
