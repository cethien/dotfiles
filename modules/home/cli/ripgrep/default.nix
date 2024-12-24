{ lib, config, ... }:

{
  options.deeznuts.cli.ripgrep.enable = lib.mkEnableOption "Enable ripgrep";

  config = lib.mkIf config.deeznuts.cli.ripgrep.enable {
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
