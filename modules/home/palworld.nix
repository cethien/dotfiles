# modules/home/palworld-save-tools.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.palworld-save-tools;

  pname = "palworld-save-tools";
  version = "2.3.3";

  src = pkgs.fetchurl {
    url = "https://github.com/deafdudecomputers/PalworldSaveTools/releases/download/v2.3.3/PalworldSaveTools-v2.3.3-linux.AppImage";
    hash = "sha256-GKwWRzODlheyc5ejZk9yTo3O+C4PWXhYRVwqwslXIfI=";
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  palworld-save-tools-pkg = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs:
      with pkgs; [
        libglvnd
        libx11
        libxcursor
        libxrandr
        libxi
        zstd
      ];
  };
in {
  options.programs.palworld-save-tools.enable = mkEnableOption "Palworld Save Tools";

  config = mkIf cfg.enable {
    home.packages = [palworld-save-tools-pkg];

    xdg.desktopEntries.palworld-save-tools = {
      name = "Palworld Save Tools";
      comment = "Edit and manage Palworld save files";
      exec = "${palworld-save-tools-pkg}/bin/palworld-save-tools";
      icon = "${appimageContents}/.DirIcon";
      categories = ["Game" "Utility"];
    };
  };
}
