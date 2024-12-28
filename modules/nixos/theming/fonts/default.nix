{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.theming.fonts;
in
{
  options.deeznuts.theming.fonts = {
    enable = mkEnableOption "Enable fonts";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      roboto
      open-sans

      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.code-new-roman

      nerd-fonts.jetbrains-mono
    ];
  };
}
