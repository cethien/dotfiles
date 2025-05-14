{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fastfetch;
in
{
  options.deeznuts.programs.fastfetch = {
    enable = mkEnableOption "fastfetch";
  };
  config = mkIf cfg.enable {
    home.file.".local/share/assets/logo.png".source = ./logo.png;
    home.file.".local/share/assets/bernd.png".source = ./bernd.png;

    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./settings.json));
    };

    home.shellAliases.ff = "fastfetch";
  };
}
