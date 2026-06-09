{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  inherit (config.lib.deeznuts.hyprland) mkExecBind;
  cfg = config.programs.rofi;
in {
  options.programs.rofi.powermenu = {
    options = mkOption {
      type = types.str;
      default = "shutdown/suspend/reboot";
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = import ./rofi-theme.nix {inherit config lib;};

    home.packages = with pkgs; [gpu-screen-recorder];

    xdg.configFile."rofimoji.rc".text = ''
      action = type
      skin-tone = neutral
      prompt = "🍞 "
    '';

    xdg.desktopEntries.rofi-freerdp = mkIf config.programs.freerdp.enable {
      name = "FreeRDP";
      comment = "Launch the FreeRDP menu via Rofi";
      exec = "${pkgs.writeShellScriptBin "rofi-freerdp" (builtins.readFile ./rofi-freerdp.sh)}/bin/rofi-freerdp";
      icon = "remote-desktop";
      terminal = false;
      type = "Application";
      categories = ["Network" "Utility"];
    };

    wayland.windowManager.hyprland.settings = {
      layer_rule = [
        {
          _args = [
            {
              match = {namespace = "rofi";};
              blur = true;
              dim_around = true;
            }
          ];
        }
      ];

      bind = let
        pm = ''
          rofi -show power-menu \
          -modi "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu \
          --choices=${cfg.powermenu.options} --confirm=\"\""
        '';
        powermenu = pkgs.writeShellScriptBin "rofi-powermenu" pm;
        tmux = pkgs.writeShellScriptBin "rofi-tmux" (builtins.readFile ./rofi-tmux.sh);
        screenrecord = pkgs.writeShellScriptBin "rofi-screenrecord" (builtins.readFile ./rofi-screenrecord.sh);
      in [
        (mkExecBind "SUPER + Space" "rofi -show drun -theme-str 'configuration{show-icons:true;}'" {})
        (mkExecBind "SUPER + Tab" "rofi -show window" {})

        (mkExecBind "SUPER + Escape" "${powermenu}/bin/rofi-powermenu" {})
        (mkExecBind "SUPER + Return" "${tmux}/bin/rofi-tmux" {})
        (mkExecBind "SUPER + Period" "${pkgs.rofimoji}/bin/rofimoji" {})
        (mkExecBind "SUPER + R" "${screenrecord}/bin/rofi-screenrecord" {})
      ];
    };
  };
}
