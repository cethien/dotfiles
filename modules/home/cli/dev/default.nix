{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev;
in
{
  imports = [
    ./gh
    ./git
    ./lazydocker
    ./lazygit
    ./jq
    ./dblab
  ];

  options.deeznuts.cli.dev = {
    enable = mkEnableOption "Enable dev tools";
  };

  config = mkIf cfg.enable {
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
