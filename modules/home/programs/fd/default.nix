{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fd;
in
{
  options.deeznuts.programs.fd = {
    enable = mkEnableOption "Enable fd";
  };

  config = mkIf cfg.enable {
    programs.fd.enable = true;
    home.shellAliases = {
      find = "fd";
      ff = "fd --type f";
      ffd = "fd --type d";
    };
  };
}
