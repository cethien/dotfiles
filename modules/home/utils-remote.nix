{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.utils-remote;
in {
  options.programs.utils-remote.enable = lib.mkEnableOption "utils for remote stuff";

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

    home.packages = with pkgs; [
      localsend
      jocalsend
      castnow
      croc
    ];
  };
}
