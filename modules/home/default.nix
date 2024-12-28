{ lib, inputs, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts;
in
{
  imports = [
    ../shared
    ./cli
    ./services
    ./desktop
    ./apps
    ./theming

    inputs.sops-nix.homeManagerModules.sops
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nur.modules.homeManager.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.deeznuts = {
    username = mkOption {
      type = str;
      default = "cethien";
      description = "The user name to use for home-manager";
    };
  };

  config = {
    home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

    home.username = cfg.username;
    home.homeDirectory = "/home/${cfg.username}";

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);

    programs.home-manager.enable = true;
  };
}
