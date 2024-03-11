{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # ./typst.nix
    ./nil.nix
    # ./nushell.nix
  ];
  programs.helix = let
    inherit (config.paint.core) _ctp_flavor;
  in {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.helix;
    defaultEditor = true;
    settings = {
      editor = {
        auto-save = false; # just got annoying
        # bufferline = "multiple";
        completion-replace = true;
        completion-trigger-len = 0;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        cursorline = true;
        indent-guides.render = true;
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        shell = ["nu" "-l" "-c"];
      };
      keys = {
        insert = {
          j.j = "normal_mode";
          j.k = "normal_mode";
        };
        normal = {
          H = ":buffer-previous";
          K = "hover";
          L = ":buffer-next";
          space.c = ":buffer-close";
          space.q = ":quit";
          space.tab = ":buffer-next";
          space.w = ":write";
        };
      };
      theme = "catppuccin_${_ctp_flavor}_transparent";
    };

    themes."catppuccin_${_ctp_flavor}_transparent" =
      # import ./catppuccin_mocha.nix;
      {
        inherits = "catppuccin_${_ctp_flavor}";
        "ui.background" = {};
      };

    languages = {
      language-server = {
        # rust-analyzer expects cargo to be in $PATH. idk how to cleanly handle it, maybe wrapper?
        # rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
        lua-language-server.command = "${pkgs.lua-language-server}/bin/lua-language-server";
      };
    };
  };
}
