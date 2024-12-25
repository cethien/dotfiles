{ lib, inputs, config, ... }:
{
  imports = [
    ../shared
    ./apps
    ./cli
    ./desktop
    ./theming
    ./user-scripts

    inputs.sops-nix.homeManagerModules.sops
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nur.modules.homeManager.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = ${config.users.users.cethien.name};
      description = "The user name to use for home-manager";
    };

    isWSL = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether the system is running in WSL";
    };
  };

  config = {
    home.username = config.username;
    home.homeDirectory = "/home/${config.username}";

    home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);

    programs.home-manager.enable = true;
  };
}
