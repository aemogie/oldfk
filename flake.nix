{
  description = "aemogie's config: i like pretty things";

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    self,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = let
      system = {
        system ? builtins.currentSystem,
        isVm ? false,
      }: let
        specialArgs = {inherit inputs isVm;};
      in
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./host
            ./home
            home-manager.nixosModules.home-manager
            {home-manager.extraSpecialArgs = specialArgs;}
          ];
        };
    in {
      nixos = system {};
      vmnix = system {isVm = true;};
    };
  };

  nixConfig = {
    # sandbox = false;
    builders-use-substitutes = true;
    keep-going = true;
    extra-substituters = [
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ue4-nixpkgs.url = "github:yvt/nixpkgs/update-ue4";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typst-lsp = {
      url = "github:nvarner/typst-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dont follow nixpkgs for these, they hv binary caches

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    helix.url = "github:helix-editor/helix";
    # helix-icons.url = "github:lazytanuki/helix/icons"; # tried it, dont rlly like it.

    anyrun.url = "github:Kirottu/anyrun";
    ctp.url = "path:/home/aemogie/dev/ctp/nix";
    spicetify = {
      url = "github:the-argus/spicetify-nix/48-fix-schema";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
