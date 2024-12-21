{ lib, config, ... }:

{
  options.cli.fd.enable = lib.mkEnableOption "Enable fd";

  config = lib.mkIf config.cli.fd.enable {
    programs.fd.enable = true;

    home.shellAliases = {
      find = "fd";
      ff = "fd --type f";
      ffd = "fd --type d";
    };
  };
}
