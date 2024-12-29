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
        default = "de";
        description = "The keyboard layout to use";
      };

      variant = mkOption {
        type = str;
        default = "nodeadkeys";
        description = "The keyboard variant to use";
      };
    };

    keyMap = mkOption {
      type = str;
      default = "de-latin1-nodeadkeys";
      description = "The keymap to use";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.xkb = with cfg.xkb; {
      inherit layout variant;
    };

    console.keyMap = cfg.keyMap;
  };
}
