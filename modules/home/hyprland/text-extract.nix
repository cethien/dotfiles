{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.lib.deeznuts.hyprland) mkExecBind;
  cfg = config.programs.text-extract;
in {
  options.programs.text-extract.enable = mkEnableOption "hyprshot";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = let
      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
      tesseract = "${pkgs.tesseract}/bin/tesseract";
      clip = "${pkgs.wl-clipboard}/bin/wl-copy";

      p = pkgs.writeShellScriptBin "text-extract" ''
        ${grim} -g "$(${slurp})" - | ${tesseract} - stdout -l deu+eng | ${clip}
      '';
    in [
      (mkExecBind "SUPER + SHIFT + T" "${p}/bin/text-extract" {})
    ];
  };
}
