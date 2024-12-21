{ lib, inputs, ... }:

{
  options.isWSL = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether the system is running in WSL";
  };

  imports = [
    ./cli
    ./desktop
    ./apps

    ./user-scripts

    inputs.nur.modules.homeManager.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = {
    home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);

    programs.home-manager.enable = true;
  };
} 
