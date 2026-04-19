{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  imports = [./rofi-theme.nix];

  options.wayland.windowManager.hyprland.rofiPowerMenuOptions = lib.mkOption {
    type = lib.types.str;
    default = "shutdown/reboot";
  };

  config = mkIf config.programs.rofi.enable {
    xdg.configFile."rofimoji.rc".text = ''
      action = type
      skin-tone = neutral
      prompt = "🍞 "
    '';

    xdg.desktopEntries.rofi-freerdp = let
      rofiEnabled = config.programs.rofi.enable;
      c = config.programs.freerdp;
      hasConnections = !isNull c.connections && c.connections != {};
    in
      mkIf (rofiEnabled && hasConnections) {
        name = "FreeRDP";
        comment = "Launch the FreeRDP menu via Rofi";
        exec = "${pkgs.writeShellScriptBin "rofi-freerdp" (builtins.readFile ./rofi-freerdp.sh)}/bin/rofi-freerdp";
        icon = "remote-desktop";
        terminal = false;
        type = "Application";
        categories = ["Network" "Utility"];
      };

    wayland.windowManager.hyprland.settings = {
      bind = let
        opt = config.wayland.windowManager.hyprland.rofiPowerMenuOptions;
        pwr = pkgs.writeShellScriptBin "rofi-power" ''
          rofi -show power-menu \
          -modi "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu \
          --choices=${opt} --confirm=\"\""
        '';
      in [
        "SUPER, Space, exec, rofi -show drun -theme-str 'configuration{show-icons:true;}'"

        "SUPER, Tab, exec, rofi -show window"

        "SUPER, escape, exec, ${pwr}/bin/rofi-power"

        "SUPER, M, exec, ${
          pkgs.writeShellScriptBin "rofi-audio" (builtins.readFile ./rofi-audio.sh)
        }/bin/rofi-audio"

        "SUPER, W, exec, ${
          pkgs.writeShellScriptBin "rofi-websearch" (builtins.readFile ./rofi-websearch.sh)
        }/bin/rofi-websearch"

        "SUPER, N, exec, ${
          pkgs.writeShellScriptBin "rofi-net" (builtins.readFile ./rofi-net.sh)
        }/bin/rofi-net"

        "SUPER, RETURN, exec, ${
          pkgs.writeShellScriptBin "rofi-tmux" (builtins.readFile ./rofi-tmux.sh)
        }/bin/rofi-tmux"

        "SUPER, B, exec, ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth"

        "SUPER, R, exec, ${
          pkgs.writeShellScriptBin "rofi-screenrecord" (builtins.readFile ./rofi-screenrecord.sh)
        }/bin/rofi-screenrecord"

        ''SUPER, PERIOD, exec, ${pkgs.rofimoji}/bin/rofimoji''
      ];
    };
  };
}
