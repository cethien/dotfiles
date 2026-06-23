{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.apps-creative;
in {
  options.programs.apps-creative.enable = lib.mkEnableOption "basic creative apps";

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      openRulesMerged = {
        "image/svg+xml" = ["inkscape"];
        "image/*" = ["krita" "gimp"];
        "audio/*" = ["kwave"];
      };

      settings.opener = {
        inkscape = [
          {
            run = ''inkscape "$@"'';
            desc = "Inkscape";
            for = "unix";
          }
        ];
        gimp = [
          {
            run = ''gimp "$@"'';
            desc = "GIMP";
            for = "unix";
          }
        ];

        krita = [
          {
            run = ''krita "$@"'';
            desc = "Krita";
            for = "unix";
          }
        ];

        kwave = [
          {
            run = ''kwave "$@"'';
            desc = "KWave";
            for = "unix";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      gimp
      krita
      inkscape

      # fonts
      helvetica-neue-lt-std
      (google-fonts.override {
        fonts = [
          "Inter"
          "Montserrat"
        ];
      })
    ];
  };
}
