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
        "audio/*" = ["castnow"];
        "video/*" = ["castnow-transcode"];
        "video/mp4" = ["castnow"];
        "video/webm" = ["castnow"];
      };

      settings.opener = {
        castnow = [
          {
            run = ''caligula "$@"'';
            desc = "Cast to Chromecast";
            for = "unix";
            block = true;
          }
        ];
        castnow-transcode = [
          {
            run = ''caligula --tomp4 "$@"'';
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
