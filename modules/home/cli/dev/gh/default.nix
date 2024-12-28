{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev.gh;
in
{
  options.deeznuts.cli.dev.gh = {
    enable = mkEnableOption "Enable gh";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enable";
      };
    };

    programs.gh-dash.enable = true;
  };
}
