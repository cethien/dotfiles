{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop;
in
{

  config = mkIf (cfg.gnome.enable || cfg.plasma6.enable || cfg.hyprland.enable) {
    home.packages = with pkgs; [
      roboto
      open-sans
    ] ++
    (with pkgs.nerd-fonts;[
      fira-code
      fira-mono
      jetbrains-mono

      code-new-roman
      hack
      meslo-lg
    ]);
  };
}
