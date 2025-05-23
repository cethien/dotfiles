{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.md;
in
{
  options.deeznuts.programs.md = {
    enable = mkEnableOption "markdown-viewer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ mdcat glow ];
  };
}
