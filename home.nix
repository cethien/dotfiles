{ inputs, user, ... }:

{
  home.username = "${user.username}";
  home.homeDirectory = "/home/${user.username}";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  programs.home-manager.enable = true;

  imports = [
    ./modules/home/${user.username}

    inputs.nur.modules.homeManager.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING
}
