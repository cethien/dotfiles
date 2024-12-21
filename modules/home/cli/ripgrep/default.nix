{ lib, config, ... }:

{
  options.cli.ripgrep.enable = lib.mkEnableOption "Enable ripgrep";

  config = lib.mkIf config.cli.ripgrep.enable {
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
