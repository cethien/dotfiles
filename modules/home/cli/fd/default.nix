{ lib, config, ... }:

{
  options.deeznuts.cli.fd.enable = lib.mkEnableOption "Enable fd";

  config = lib.mkIf config.deeznuts.cli.fd.enable {
    programs.fd.enable = true;

    home.shellAliases = {
      find = "fd";
      ff = "fd --type f";
      ffd = "fd --type d";
    };
  };
}
