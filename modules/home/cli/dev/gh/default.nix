{ lib, config, ... }:

{
  options.deeznuts.cli.dev.gh.enable = lib.mkEnableOption "Enable gh";

  config = lib.mkIf config.deeznuts.cli.dev.gh.enable {
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
