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
    programs.pandoc = {
      templates = {
        "office.yaml" = pkgs.writeText "office.yaml" (import ./templates/office.nix);

        "academic.yaml" = pkgs.writeText "academic.yaml" (import ./templates/academic.nix);
      };
    };

    programs.yazi = {
      openRulesMerged = {
        "text/plain" = ["$EDITOR" "pandoc"];
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
  };
}
