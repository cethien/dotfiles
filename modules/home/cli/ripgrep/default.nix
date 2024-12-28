{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.ripgrep;
in
{
  options.deeznuts.cli.ripgrep = {
    enable = mkEnableOption "Enable ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
    };

    home.shellAliases.grep = "rg";
  };
}
