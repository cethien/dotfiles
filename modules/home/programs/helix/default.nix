{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.deeznuts.programs.helix;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.helix = {
    enable = mkEnableOption "Helix editor";
  };

  config = mkIf enabled {
    home.sessionVariables.EDITOR = "hx";
    programs.helix = {
      enable = true;

      defaultEditor = mkDefault true;
      settings = {
        editor = {
          line-number = "absolute";
          cursorline = true;
          color-modes = true;

          lsp.display-messages = true;

          cursor-shape = {
            insert = "bar";
            normal = "bar";
            select = "underline";
          };
        };

        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
    };
  };
}
