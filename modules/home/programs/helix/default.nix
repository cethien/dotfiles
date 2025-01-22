{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.deeznuts.programs.helix;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.helix = {
    enable = mkEnableOption "Helix editor";
  };

  config = mkIf enabled {
    home.sessionVariables.EDITOR = "hx";

    programs.helix = {
      enable = true;
      defaultEditor = mkDefault true;

      languages = import ./languages;
      settings = import ./settings.nix;

    };
  };
}
