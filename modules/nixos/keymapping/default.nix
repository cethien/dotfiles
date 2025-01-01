{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts.keymapping;
in
{
  options.deeznuts.keymapping = {
    enable = mkEnableOption "Enable keymapping";

    xkb = {
      layout = mkOption {
        type = str;
        default = "";
        description = "The keyboard layout to use";
      };

      variant = mkOption {
        type = str;
        default = "";
        description = "The keyboard variant to use";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.xkb = with cfg.xkb; {
      inherit layout variant;
    };

    console.useXkbConfig = true;
  };
}
