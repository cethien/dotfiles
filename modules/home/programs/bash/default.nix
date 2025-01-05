{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.bash;
in
{
  imports = [
    ./blesh.nix
    ./nix-profile.nix
  ];

  options.deeznuts.programs.bash = {
    enable = mkEnableOption "Enable bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      blesh.enable = true;
    };
  };
}
