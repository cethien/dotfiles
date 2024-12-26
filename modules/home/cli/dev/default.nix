{ lib, config, ... }:
{
  imports = [
    ./gh
    ./git
    ./lazydocker
    ./lazygit
    ./jq
    ./dblab
  ];

  options.deeznuts.cli.dev.enable = lib.mkEnableOption "Enable dev tools";

  config = lib.mkIf config.deeznuts.cli.dev.enable {
    deeznuts.cli.dev = {
      git.enable = true;
      gh.enable = true;
      lazydocker.enable = true;
      lazygit.enable = true;
      jq.enable = true;
      dblab.enable = true;
    };
  };
}
