{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.lib.deeznuts) mkMimeApps;

  utils = import ./utils.nix {inherit pkgs;};
  ui = import ./ui.nix {inherit pkgs;};
  languages = import ./languages.nix {inherit pkgs;};
  autocomplete = import ./autocomplete.nix {inherit pkgs;};

  extraPackages = with pkgs;
    [
      ripgrep
      fd
      bat
      fzf
    ]
    ++ ui.extraPackages ++ utils.extraPackages ++ languages.extraPackages ++ autocomplete.extraPackages;

  plugins = with pkgs.vimPlugins;
    [
      mini-nvim
      fzf-lua
      auto-session
    ]
    ++ ui.plugins ++ utils.plugins ++ languages.plugins ++ autocomplete.plugins;

  initLua = ''
    ${builtins.readFile ./init.lua}
    ${ui.initLua}
    ${utils.initLua}
    ${languages.initLua}
    ${autocomplete.initLua}
  '';
in {
  config = mkIf config.programs.neovim.enable {
    programs.neovim = {
      viAlias = true;
      vimAlias = true;
      inherit extraPackages plugins initLua;

      #legacy
      withRuby = false;
      withPython3 = false;
    };
    stylix.targets.neovim.enable = false;

    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.v = "nvim";
    programs.tmux.resurrectPluginProcesses = ["nvim .nvim-wrapped"];

    home.packages = [pkgs.nvimpager];
    home.sessionVariables.PAGER = "nvimpager";

    xdg.mimeApps.defaultApplications = mkMimeApps {
      text = {
        desktop = "nvim.desktop";
        types = [
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
          # "text/html"
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
      };
    };
  };
}
