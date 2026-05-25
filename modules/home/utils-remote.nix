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
    home.packages = with pkgs; [
      localsend
      jocalsend
      castnow
      croc
    ];
  };
}
