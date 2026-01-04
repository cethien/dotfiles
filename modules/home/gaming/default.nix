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
    ./minecraft.nix
    ./retroarch.nix
  ];

  options.programs = {
    steam.enable = mkEnableOption "steam stuff";
    r2modman.enable = mkEnableOption "r2modmanager";
    pokemmo.enable = mkEnableOption "pokemmo";
  };

  config = {
    home.packages = mkMerge [
      (mkIf config.programs.pokemmo.enable [pkgs.pokemmo-installer])
      (mkIf config.programs.r2modman.enable [pkgs.r2modman])
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf (config.programs.steam.enable && (builtins.elem "steam" as)) ["steam -silent"];
      windowrulev2 = mkMerge [
        (mkIf config.programs.steam.enable [
          "workspace ${toString ws}, initialClass:^(steam_app_.*)$"
          "immediate, initialClass:^(steam_app_.*)$"
        ])
        (mkIf config.programs.pokemmo.enable [
          "workspace ${toString ws}, title:^(.*PokeMMO.*)$"
          "fullscreen, title:^(.*PokeMMO.*)$"
          "immediate, title:^(.*PokeMMO.*)$"
        ])
      ];
    };
  };
}
