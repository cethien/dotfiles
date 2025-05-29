{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.gaming;
in {
  imports = [
    ./mangohud.nix
    ./steam.nix
    ./prismlauncher.nix
    ./r2modman.nix
    ./retroarch.nix
    ./pokemmo.nix
  ];

  options.deeznuts.programs.gaming = {
    enable = mkEnableOption "all gaming apps";
  };

  config.deeznuts.programs.gaming = mkIf cfg.enable {
    mangohud.enable = true;
    steam.enable = true;
    prismlauncher.enable = true;
    retroarch.enable = true;
    pokemmo.enable = true;
  };
}
