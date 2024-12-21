{ lib, config, ... }:

{
  options.cli.gh.enable = lib.mkEnableOption "Enable gh";

  config = lib.mkIf config.cli.gh.enable {
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
