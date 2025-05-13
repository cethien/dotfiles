{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    stylix.enable = true;

    programs = {
      hyprland = {
        enable = true;
        hypridle.enable = true;

        programs = {
          spotify.autostart.enable = true;
        };
      };

      cli.enable = true;
      basic.enable = true;
      vscode.enable = true;
      obs-studio.enable = true;
    };
  };
}
