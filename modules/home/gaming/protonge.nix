{ lib, config, pkgs, ... }:

{
  options.gaming.protonge.enable = lib.mkEnableOption "Enable protonge";

  config = lib.mkIf config.gaming.protonge.enable {
    home.packages = with pkgs; [ protonup ];

    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH =
        "\${HOME}/.stream/root/compatibilitytools.d";
    };
  };
}
