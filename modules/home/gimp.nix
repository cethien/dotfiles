{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.gimp;
in {
  options.programs.gimp.enable = lib.mkEnableOption "gimp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.gimp-with-plugins.override {
        plugins = with pkgs.gimpPlugins; [
          gmic
          resynthesizer
        ];
      })
    ];

    programs.yazi = {
      openRulesMerged = {
        "image/*" = ["gimp"];
      };

      settings.opener = {
        gimp = [
          {
            run = ''gimp "$@"'';
            desc = "GIMP";
            for = "unix";
          }
        ];
      };
    };
  };
}
