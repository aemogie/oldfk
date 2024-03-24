name: path: {
  lib,
  config,
  options,
  ...
}: {
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
}
