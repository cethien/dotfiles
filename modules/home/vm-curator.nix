{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.vm-curator;
in {
  options.programs.vm-curator.enable = mkEnableOption "vm-curator";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vm-curator
    ];

    programs.tmux.launcher.settings.entries = [
      {
        name = "vm-curator";
        icon = "";
        exec = "vm-curator";
        preview_text = "A *TUI application* to manage your `QEMU` VM library";
      }
    ];
  };
}
