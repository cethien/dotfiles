{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    stylix.enable = true;

    desktop.hyprland = {
      enable = true;
    };

    programs = {
      cli.enable = true;
      basic.enable = true;
      gaming.enable = true;

      spotify.spotify-player.enable = true;
      discord.enable = true;

      obs-studio.enable = true;
    };
  };
}
