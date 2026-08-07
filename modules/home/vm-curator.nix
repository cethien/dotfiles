{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.vm-curator;
in {
  options.programs.vm-curator.enable = mkEnableOption "fast and friendly TUI to build and manage QEMU/KVM virtual machines";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vm-curator
    ];

    programs.tmux.launcher.entries = [
      {
        name = "vm-curator";
        icon = "";
        exec = "vm-curator";
        preview = "echo 'manage VMs'";
      }
    ];
  };
}
