{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.direnv;
in
{
  options.deeznuts.programs.direnv = {
    enable = mkEnableOption "Enable direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;

      config = {
        global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };
    };
  };
}
