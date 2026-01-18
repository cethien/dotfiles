{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
  as = config.wayland.windowManager.hyprland.autostart;
in {
  imports = [
    ./steam.nix
    ./minecraft.nix
    ./retroarch.nix
  ];

  options.programs = {
    r2modman.enable = mkEnableOption "r2modmanager";
    pokemmo.enable = mkEnableOption "pokemmo";
  };

  config = {
    home.packages = mkMerge [
      (mkIf config.programs.pokemmo.enable [pkgs.pokemmo-installer])
      (mkIf config.programs.r2modman.enable [pkgs.r2modman])
    ];

    wayland.windowManager.hyprland.settings = {
      windowrule = let
        mkGame = match: pkgs.cethien.mkHyprGameWindowRule match "${toString ws}";
      in
        mkMerge [
          (mkIf config.programs.pokemmo.enable (mkGame "match:title ^(.*PokeMMO.*)$"))
        ];
    };
  };
}
