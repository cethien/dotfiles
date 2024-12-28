{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.shell.bash;
in
{
  imports = [
    ./blesh.nix
    ./nix-profile.nix
  ];

  options.deeznuts.cli.shell.bash = {
    enable = mkEnableOption "Enable bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      blesh.enable = true;
    };
  };
}
