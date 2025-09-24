{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.v = "nvim";

    programs.nvf.enable = true;
    programs.nvf.settings = import ./nvf-config.nix {
      inherit pkgs;
      ageFile = config.sops.age.keyFile;
    };
    stylix.targets.nvf.enable = false;

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "text/plain"
        "text/x-c"
        "text/x-c++"
        "text/x-java"
        "text/x-python"
        "text/x-shellscript"
        "text/x-makefile"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-patch"
        "text/x-tex"
        "text/x-perl"
        "text/x-rustsrc"
        "text/x-go"
        "text/x-lua"
        "text/x-sql"
        "text/x-markdown"
        "text/markdown"
        "text/x-log"
        "text/x-readme"
        "text/x-copying"
        "text/x-authors"
        "text/x-install"
        "text/x-cmake"
        "text/x-yaml"
        "text/x-toml"
        "text/x-ini"
        "text/x-properties"
        "text/x-po" # gettext translation
        "text/x-sass"
        "text/x-scss"
        "text/css"
        "text/html"
        "application/javascript"
        "application/x-javascript"
        "application/json"
        "application/ld+json"
        "application/xml"
        "text/xml"
        "application/x-sh"
        "application/x-shellscript"
        "inode/x-empty" # empty file
        "inode/directory" # may be opened in tree-style editors
      ];
    in
      builtins.listToAttrs (map (mime: {
          name = mime;
          value = "nvim.desktop";
        })
        mimeTypes);
  };
}
