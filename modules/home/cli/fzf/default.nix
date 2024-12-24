{ lib, config, ... }:
{
  options.deeznuts.cli.fzf.enable = lib.mkEnableOption "Enable fzf";

  config = lib.mkIf config.deeznuts.cli.fzf.enable {
    programs.fzf.enable = true;
  };
}
