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
      templates = let
        office = pkgs.writeText "office" (import ./templates/office.nix {inherit pkgs;});
        academic = pkgs.writeText "academic" (import ./templates/office.nix {inherit pkgs;});
      in {
        "office.pptx" = office;
        "academic.pdf" = academic;
      };
    };

    programs.yazi = {
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
