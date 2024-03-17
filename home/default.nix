{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  build-user = name: path: {lib, ...}: {
    config = {
      users.users.${name} = {
        isNormalUser = true;
        description = "${name}";
        initialPassword = "password";
        extraGroups = ["networkmanager" "wheel" "adbusers"];
        shell = config.home-manager.users.${name}.home.loginShell;
      };

      home-manager.users.${name} = {
        imports = [path];
        options.home.loginShell = (options.users.users.type.getSubOptions []).shell;
        config = {
          nixpkgs.config.allowUnfree = true;

          home = {
            username = name;
            homeDirectory = "/home/${name}";
          };

          systemd.user.startServices = "sd-switch";

          home = {inherit (config.system) stateVersion;};
        };
      };
    };
  };
in {
  imports = [(build-user "aemogie" ./user/aemogie.nix)];
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
  config.home-manager.sharedModules = config.hm;
  config.hm = {
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

  config.home-manager.useUserPackages = true;
}
