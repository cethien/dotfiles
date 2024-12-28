{ lib, config, pkgs, ... }:
let
  cfg = config.deeznuts.cli.shell.bash;
in
{
  imports = [
    ./blesh.nix
    ./nix-profile.nix
  ];

  options.deeznuts.cli.shell.bash = {
    enable = lib.mkEnableOption "Enable bash";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      blesh.enable = true;
    };
  };
}
