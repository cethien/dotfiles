{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optionals;
  cfg = config.programs.utils-remote;
in {
  options.programs = {
    utils-remote.enable = mkEnableOption "utils for remote stuff";
    localsend.enable = mkEnableOption "localsend";
    jocalsend.enable = mkOption {
      type = types.bool;
      default = config.programs.localsend.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      openRulesMerged = {
        "audio/*" = [
          {
            name = "castnow";
            prio = 30;
          }
        ];
        "video/*" = [
          {
            name = "castnow-transcode";
            prio = 30;
          }
        ];
        "video/mp4" = [
          {
            name = "castnow";
            prio = 30;
          }
        ];
        "video/webm" = [
          {
            name = "castnow";
            prio = 30;
          }
        ];
      };

      settings.opener = {
        castnow = [
          {
            run = ''castnow %s'';
            desc = "Cast to Chromecast";
            for = "unix";
            block = true;
          }
        ];
        castnow-transcode = [
          {
            run = ''castnow --tomp4 %s'';
            desc = "Cast to Chromecast (Transcode)";
            for = "unix";
            block = true;
          }
        ];
      };
    };

    home.packages = with pkgs;
      [castnow]
      ++ optionals config.programs.localsend.enable [localsend]
      ++ optionals config.programs.jocalsend.enable [jocalsend];
  };
}
