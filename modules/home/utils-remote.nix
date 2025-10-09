{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
in {
  options.programs.remoteUtils = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.programs.remoteUtils.enable {
    home.packages = with pkgs; [
      freerdp
      tigervnc

      castnow
      localsend
      jocalsend
    ];
  };
}
