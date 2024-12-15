{ lib, config, pkgs, ... }:

{
  options.desktop.fonts.enable = lib.mkEnableOption "Enable fonts";

  config = lib.mkIf config.desktop.fonts.enable {
    fonts.packages = with pkgs; [
      roboto
      open-sans

      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.code-new-roman
    ];
  };
}