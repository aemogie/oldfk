{
  inputs,
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  imports =
    [
      inputs.ctp.homeManagerModules.catppuccin
      ../../modules/fonts.nix
      ../../modules/typst.nix
    ]
    ++ [
      ../wm/hyprland
      ../wm/waybar
      ../wm/anyrun
      ../wm/mako.nix
      ../wm/swaylock.nix
    ]
    ++ [
      ../sh/helix
      ../sh/bat.nix
      ../sh/nushell
      ../sh/zellij.nix
      ../sh/yazi
      ../sh/starship.nix
      ../sh/direnv.nix
    ]
    ++ [
      ../apps/gtk.nix
      ../apps/firefox
      ../apps/discord
      ../apps/zathura.nix
      ../apps/aseprite.nix
      ../apps/spicetify
      ../apps/foot.nix
      # ../apps/warp
      # ../apps/wezterm
      # ../apps/ue4.nix
    ]
    ++ [];

  nix.settings.warn-dirty = false;

  # refactor
  home.packages = [
    pkgs.jetbrains.idea-community
    pkgs.fractal
    pkgs.gnome.nautilus
    pkgs.spotube
    pkgs.fd
  ];

  # this as well. maybe to ../tui?
  home.shellAliases = {
    # `clear` on nushell doesn't clear scrollback
    c = "printf '\\e[H\\e[2J\\e[3J'";
    l = "ls -la";
    o = lib.getExe pkgs.bat;
    fk = "cd ${config.home.homeDirectory}/dev/flake";
    q = "exit";
  };

  home.sessionVariables = {
    # doesnt work on bash idk why. but nushell works, though.
    LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-${osConfig.paint.active.ctp.flavor})";
  };

  programs = {
    tealdeer.enable = true;
    ripgrep.enable = true;
    typst.enable = true;
    rbw = {
      enable = true;
      settings = {
        email = "theaemogie@gmail.com";
        pinentry = "gnome3";
      };
    };

    git = {
      enable = true;
      userName = "aemogie";
      userEmail = "54412618+aemogie@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "dev";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
    gh = {
      enable = true;
      settings.version = 1; # nix-community/home-manager#4744
      settings.git_protocol = "ssh";
      gitCredentialHelper.hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
    # obs-studio = {
    #   enable = false;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     wlrobs
    #     # obs-backgroundremoval
    #     obs-pipewire-audio-capture
    #   ];
    # };
  };

  fonts = {
    packages = with pkgs; [
      # fonts
      iosevka-bin
      (iosevka-bin.override {variant = "aile";})
      (iosevka-bin.override {variant = "etoile";})
      twitter-color-emoji
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "Iosevka" "IosevkaTerm"];})
      corefonts
      helvetica-neue-lt-std
      carlito
    ];
    monospace = "Iosevka Term";
    serif = "Iosevka Etoile";
    sans = "Iosevka Aile";
    fontconfig.enable = true;
  };
  # defaultFonts = {
  #   serif = ["Iosevka Etoile"];
  #   sansSerif = ["Iosevka Aile"];
  #   monospace = ["Iosevka"];
  #   emoji = ["Twitter Color Emoji"];
  # };
}
