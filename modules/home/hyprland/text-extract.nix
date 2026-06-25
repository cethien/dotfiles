{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.text-extract;

  textExtractScript = let
    grim = "${pkgs.grim}/bin/grim";
    slurp = "${pkgs.slurp}/bin/slurp";
    tesseract = "${pkgs.tesseract}/bin/tesseract";
    clip = "${pkgs.wl-clipboard}/bin/wl-copy";
  in
    pkgs.writeShellScript "text-extract" ''
      ${grim} -g "$(${slurp})" - | ${tesseract} - stdout -l deu+eng | ${clip}
    '';
in {
  options.programs.text-extract.enable = mkEnableOption "text-extract";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraLuaFiles."99-text-extract" =
      #lua
      ''
        hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("${textExtractScript}"))
      '';
  };
}
