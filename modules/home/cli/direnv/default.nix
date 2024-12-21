{ config, lib, ... }:

{
  options.cli.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf config.cli.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config.global = {
        hide_env_diff = true;
      };
    };
  };
}
