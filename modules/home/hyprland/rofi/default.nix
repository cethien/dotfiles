{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
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

    wayland.windowManager.hyprland.extraLuaFiles."99-rofi" = let
      pmStr = ''
        rofi -show power-menu \
          -modi "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu \
          --choices=${cfg.powermenu.options} --confirm=\"\""
      '';

      powermenu = pkgs.writeShellScript "rofi-powermenu" pmStr;
      tmux = pkgs.writeShellScript "rofi-tmux" (builtins.readFile ./rofi-tmux.sh);
      rofimoji = "${pkgs.rofimoji}/bin/rofimoji";
      screenrecord = pkgs.writeShellScript "rofi-screenrecord" (builtins.readFile ./rofi-screenrecord.sh);
    in
      #lua
      ''
        hl.layer_rule({
        	match = { namespace = "rofi" },
        	blur = true,
        	dim_around = true,
        })

        hl.bind("SUPER + Space", hl.dsp.exec_cmd("rofi -show drun -theme-str 'configuration{show-icons:true;}'"))
        hl.bind("SUPER + Tab", hl.dsp.exec_cmd("rofi -show window"))

        hl.bind("SUPER + Escape", hl.dsp.exec_cmd("${powermenu}"))
        hl.bind("SUPER + Return", hl.dsp.exec_cmd("${tmux}"))
        hl.bind("SUPER + Period", hl.dsp.exec_cmd("${rofimoji}"))
        hl.bind("SUPER + R", hl.dsp.exec_cmd("${screenrecord}"))
      '';
  };
}
