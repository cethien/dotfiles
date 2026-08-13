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
    home.packages = [pkgs.vm-curator];
  };
}
