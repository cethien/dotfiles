{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = [pkgs.gradia];

    wayland.windowManager.hyprland.settings.bind = let
      cmd = mode: "${pkgs.hyprshot}/bin/hyprshot -z -o ~/Pictures -m ${mode}";

      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
      tesseract = "${pkgs.tesseract}/bin/tesseract";
      clip = "${pkgs.wl-clipboard}/bin/wl-copy";

      textExtract = pkgs.writeShellScriptBin "text-extract" ''
        ${grim} -g "$(${slurp})" - | ${tesseract} - stdout -l deu+eng | ${clip}
      '';
    in [
      ", Print, exec, ${cmd "output"} -m active"
      "ALT, Print, exec, ${cmd "window"} -m active"
      "SUPER SHIFT, S, exec, ${cmd "region"}"

      "SUPER SHIFT, T, exec, ${textExtract}/bin/text-extract"
    ];
  };
}
