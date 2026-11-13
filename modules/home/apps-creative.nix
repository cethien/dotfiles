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
        "image/*" = ["krita"];
        "audio/*" = ["audacity"];
      };

      settings.opener = {
        inkscape = [
          {
            run = ''inkscape %s'';
            desc = "Inkscape";
            for = "unix";
            orphan = true;
          }
        ];

        krita = [
          {
            run = ''krita %s'';
            desc = "Krita";
            for = "unix";
            orphan = true;
          }
        ];

        audacity = [
          {
            run = ''audacity %s'';
            desc = "Audacity";
            for = "unix";
            orphan = true;
          }
        ];
      };
    };

    home.packages = with pkgs; [
      krita
      inkscape

      audacity

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
