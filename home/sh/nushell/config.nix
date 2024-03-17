{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  programs.nushell.extraConfig = osConfig.lib.paint.misc.replaceVars {
    nixfmt = "${lib.getExe pkgs.alejandra} -q";
    pager = lib.getExe pkgs.less;
    z_editor_tab = config.programs.zellij.layouts.editor.command.new-tab;
    z_editor_new = config.programs.zellij.layouts.editor.command.new-session;
    langs = ./languages.json;
  } (lib.fileContents ./config.nu);
}
