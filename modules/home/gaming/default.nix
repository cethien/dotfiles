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
      windowrule = let
        mkGame = match: pkgs.cethien.mkHyprGameWindowRule match "${toString ws}";
      in
        mkMerge [
          (mkIf config.programs.steam.enable (mkGame "match:initial_class ^(steam_app_.*)$"))
          (mkIf config.programs.steam.enable (mkGame "match:initial_class (?i).*\.exe$"))
          (mkIf config.programs.pokemmo.enable (mkGame "match:title ^(.*PokeMMO.*)$"))
        ];
    };
  };
}
