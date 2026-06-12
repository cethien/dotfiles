{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.pandoc;
in {
  config = mkIf cfg.enable {
    programs.yazi = {
      openRulesMerged = {
        "text/plain" = ["pandoc"];
      };
      settings.opener = {
        pandoc = [
          {
            run = ''pandoc "$@"'';
            desc = "pandoc";
            for = "unix";
          }
        ];
      };
    };

    programs.pandoc.defaults = {
      citeproc = true;

      pdf-engine = "${pkgs.python313Packages.weasyprint}/bin/weasyprint";
    };
  };
}
