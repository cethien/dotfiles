{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fd;
in
{
  options.deeznuts.programs.fd = {
    enable = mkEnableOption "fd - find replacement";
  };

  config = mkIf cfg.enable {
    programs.fd.enable = true;
    home.shellAliases = {
      find = "fd";
      findf = "fd --type f";
      findd = "fd --type d";
    };
  };
}
