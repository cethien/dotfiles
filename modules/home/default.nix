{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts;
in
{
  imports = [
    ../shared
    ./cli
    ./services
    ./desktop
    ./apps
  ];

  options.deeznuts = {
    username = mkOption {
      type = str;
      default = "cethien";
      description = "The user name to use for home-manager";
    };
  };

  config = {
    programs.home-manager.enable = true;

    home.username = cfg.username;
    home.homeDirectory = "/home/${cfg.username}";
  };
}
