{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.helix.languages = {
    language-server = {
      nil = {
        command = lib.getExe pkgs.nil; # inputs.nil.packages.${pkgs.system}.nil;
        config = {
          nil.nix.flake = {
            autoArchive = true;
            autoEvalInputs = true;
          };
        };
      };
    };

    language = [
      {
        name = "nix";
        formatter = {command = lib.getExe pkgs.alejandra;};
        auto-format = true;
      }
    ];
  };
}
