{ lib, config, pkgs, ... }:

{
  options.deeznuts.theming.fonts.enable = lib.mkEnableOption "Install fonts";

  config = lib.mkIf config.deeznuts.theming.fonts.enable {
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
