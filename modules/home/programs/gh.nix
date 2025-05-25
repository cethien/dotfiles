{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.gh;
in
{
  options.deeznuts.programs.gh = {
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
