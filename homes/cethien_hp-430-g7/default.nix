{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    stylix.enable = true;

    desktop.hyprland = {
      enable = true;
      idle.enable = true;
    };

    programs = {
      cli.enable = true;
      basic.enable = true;
      vscode.enable = true;
    };
  };
}
