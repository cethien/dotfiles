{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.protonge;
in

{
  options.deeznuts.programs.protonge = {
    enable = mkEnableOption "Enable protonge";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ protonup ];

    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH =
        "~/.stream/root/compatibilitytools.d";
    };
  };
}
