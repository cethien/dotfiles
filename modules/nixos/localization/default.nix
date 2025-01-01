{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts.localization;
in
{
  options.deeznuts.localization = {
    enable = mkEnableOption "Enable localization";

    timeZone = mkOption {
      type = str;
      default = "Europe/Berlin";
      description = "The timezone to use";
    };

    locale = mkOption {
      type = str;
      default = "en_US.UTF-8";
      description = "The locale to use";
    };
    extraLocale = mkOption {
      type = str;
      default = "de_DE.UTF-8";
      description = "extralocale to use";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };
  };
}
