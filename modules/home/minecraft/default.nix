{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.minecraft;
in {
  imports = [
    ./prismlauncher.nix
  ];

  options.programs.minecraft.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.programs.prismlauncher.enable;
    description = "2 week minecraft phase";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      packwiz
      mcrcon
    ];

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-minecraft" =
        #lua
        ''
          game_windowrule({ class = "^(Minecraft.*)$" })
        '';
    };
  };
}
