{
  pkgs,
  config,
  ...
}: {
  # thanks to github.com/Stonks3141/ctp-nix
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = let
        theme = let
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "grub";
            rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
            sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
          };
        in
          pkgs.runCommand "catppuccin-grub-theme" {} ''
            mkdir -p "$out"
            cp -r ${src}/src/catppuccin-${config.paint.core._ctp_flavor}-grub-theme/* "$out"/
          '';
      in {
        enable = true;
        inherit theme;
        font = "${pkgs.iosevka-bin}/share/fonts/truetype/iosevka-regular.ttc";
        splashImage = "${theme}/background.png";
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    # suppress all messeges
    kernelParams = ["quiet" "splash"];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
