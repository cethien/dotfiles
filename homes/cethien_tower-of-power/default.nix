{
  imports = [ ../../modules/home ];

  programs.home-manager.enable = true;

  deeznuts = {
    nixpkgs.allowUnfree = true;

    catppuccin.enable = true;

    desktop.hyprland.enable = true;

    programs = {
      cli.enable = true;
      basic.enable = true;
      gaming.enable = true;
      discord.enable = true;
      obs-studio.enable = true;
    };
  };
}
