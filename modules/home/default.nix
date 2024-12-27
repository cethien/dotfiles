{ lib, inputs, config, ... }:
{
  imports = [
    ../shared
    ./apps
    ./cli
    ./desktop
    ./theming

    inputs.sops-nix.homeManagerModules.sops
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nur.modules.homeManager.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.deeznuts = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "cethien";
      description = "The user name to use for home-manager";
    };
  };

  config = {
    home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

    home.username = config.deeznuts.username;
    home.homeDirectory = "/home/${config.deeznuts.username}";

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);

    programs.home-manager.enable = true;

  };
}
