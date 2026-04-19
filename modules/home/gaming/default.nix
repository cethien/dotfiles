{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf mkOption types;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
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

  options.wayland.windowManager.hyprland.defaultWorkspaces.gaming = mkOption {
    type = types.nullOr types.int;
    default = null;
    description = "default gaming workspace";
  };

  config = {
    programs.mangohud.enable = true;
    programs.mangohud.settings = {
      position = "top-left";
      horizontal = true;
      horizontal_stretch = 0;
      hud_compact = true;
      hud_no_margin = true;
      background_alpha = lib.mkForce 0.3;

      gpu_stats = true;
      cpu_stats = true;
      histogram = true;
      frametime = false;
    };

    home.packages = mkMerge [
      (mkIf config.programs.pokemmo.enable [pkgs.pokemmo-installer])
      (mkIf config.programs.r2modman.enable [pkgs.r2modman])
    ];

    wayland.windowManager.hyprland.settings = mkIf (!isNull ws) {
      windowrule = let
        mkGame = match: pkgs.cethien.mkHyprGameWindowRule match "${toString ws}";
      in
        mkMerge [
          (mkIf config.programs.pokemmo.enable (mkGame "match:title ^(.*PokeMMO.*)$"))
        ];
    };
  };
}
