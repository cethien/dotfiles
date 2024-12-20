{ inputs, ... }:

{
  home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  programs.home-manager.enable = true;

  imports = [
    ./desktop
    ./apps
    ./gaming
    ./sh
    ./user-scripts

    ./hushlogin.nix

    inputs.nur.modules.homeManager.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
