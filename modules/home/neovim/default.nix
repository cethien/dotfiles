{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.lib.deeznuts) mkMimeApps;

  ui = import ./ui.nix {inherit pkgs;};
  languages = import ./languages.nix {inherit pkgs;};
  autocomplete = import ./autocomplete.nix {inherit pkgs;};

  extraPackages = with pkgs;
    [
      ripgrep
      fd
    ]
    ++ ui.extraPackages
    ++ autocomplete.extraPackages
    ++ languages.extraPackages;

  genpass-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "genpass-nvim";
    src = ./plugins/genpass;
    dependencies = [pkgs.genpass];
  };

  plugins = with pkgs.vimPlugins;
    [
      mini-nvim
      auto-session
      scope-nvim
      toggleterm-nvim

      nvim-sops
      csvview-nvim

      lorem-nvim
      genpass-nvim

      rest-nvim
      vim-dadbod
      vim-dadbod-ui
    ]
    ++ ui.plugins
    ++ autocomplete.plugins
    ++ languages.plugins;

  initLua = lib.mkMerge [
    (lib.mkBefore ''
      ${builtins.readFile ./init.lua}
      ${ui.initLua}
      ${languages.initLua}
      ${autocomplete.initLua}
    '')
    (lib.mkAfter ''require("scratchpad")'')
  ];
in {
  config = mkIf config.programs.neovim.enable {
    programs.neovim = {
      viAlias = true;
      vimAlias = true;
      inherit extraPackages plugins initLua;

      # legacy
      withRuby = false;
      withPython3 = false;
    };
    stylix.targets.neovim.enable = false;

    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.v = "nvim";
    programs.tmux.resurrectPluginProcesses = [''"~nvim->nvim *"''];

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
