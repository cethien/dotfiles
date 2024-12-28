{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.fd;
in
{
  options.deeznuts.cli.fd = {
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
