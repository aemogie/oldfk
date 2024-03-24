{
  config,
  options,
  lib,
  pkgs,
  ...
}: {
  imports = [(import ./build.nix "aemogie" ./user/aemogie.nix)];
  options.hm = with lib;
    mkOption {
      type = let
        base = options.home-manager.sharedModules.type;
        wrap = val:
          if (builtins.typeOf val) == "list"
          then val
          else [val];
      in
        base
        // {
          check = a: true;
          merge = loc: defs: base.merge loc (map (it: it // {value = wrap it.value;}) defs);
        };
      default = [];
    };
  config = {
    hm = {
      programs = {
        bash.enable = true; # for the env vars
        git.enable = true;
      };
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
      home.packages = [
        pkgs.xdg-utils
        pkgs.xdg-user-dirs
      ];
    };
    home-manager = {
      sharedModules = config.hm;
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
