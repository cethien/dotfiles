{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fastfetch;
in {
  options.deeznuts.programs.fastfetch = {
    enable = mkEnableOption "fastfetch";
  };
  config = mkIf cfg.enable {
    home.file.".config/fastfetch/logo.png".source = ./bernd_pixel.png;
    home.shellAliases.ff = "fastfetch";

    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./settings.json));
    };
  };
}
