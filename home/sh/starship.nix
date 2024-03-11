{
  pkgs,
  config,
  ...
}: let
  inherit (config.paint.core) _ctp_flavor;
in {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings =
      {
        # add_newline = false;
        palette = "catppuccin_${_ctp_flavor}";
        # format = "$fill$line_break$all$line_break$character";
        # fill = {
        #   style = "surface2";
        #   symbol = "─";
        # };
      }
      // fromTOML (builtins.readFile "${pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "starship";
        rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
        sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      }}/palettes/${_ctp_flavor}.toml");
  };
}
