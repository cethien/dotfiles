{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.deeznuts.programs.pim;
in {
  imports = [
    ./email.nix
    ./calendar.nix

    ./thunderbird.nix
  ];

  options.deeznuts.programs.pim.enable = mkEnableOption "pim";

  config = mkIf cfg.enable {
    deeznuts.programs.pim = {
      email.enable = mkDefault true;
      calendar.enable = mkDefault true;
    };
  };
}
