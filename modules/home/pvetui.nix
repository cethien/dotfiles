{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.pvetui;
  yamlFormat = pkgs.formats.yaml {};
  inherit (lib) mkEnableOption mkOption mkIf types mkDefault;
  c = config.lib.stylix.colors.withHashtag;
in {
  options.programs.pvetui = {
    enable = mkEnableOption "pvetui - a TUI for Proxmox VE";

    package = mkOption {
      type = types.package;
      default = pkgs.pvetui;
      description = "The pvetui package to use.";
    };

    settings = mkOption {
      type = yamlFormat.type;
      default = {};
      description = "Configuration for pvetui, generated as TOML.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    programs.pvetui.settings = {
      cache_dir = mkDefault "${config.xdg.cacheHome}/pvetui";
      show_icons = mkDefault true;

      theme = {
        name = mkDefault "stylix";
        colors = {
          background = c.base00;
          foreground = c.base05;

          success = c.base0B;
          warning = c.base0A;
          error = c.base08;
          info = c.base0D;

          border = c.base03;
          active_border = c.base0D;
          selection = c.base02;
          selection_text = c.base05;

          gauge_buffer = c.base01;
          gauge_fill = c.base0B;
        };
      };

      plugins = {
        enabled = mkDefault [];
      };

      key_bindings = {
        switch_view = mkDefault "]";
        switch_view_reverse = mkDefault "[";
        nodes_page = mkDefault "Alt+1";
        guests_page = mkDefault "Alt+2";
        tasks_page = mkDefault "Alt+3";
        storage_page = mkDefault "Alt+4";
        tasks_toggle_queue = mkDefault "t";
        task_stop_cancel = mkDefault "x";
        menu = mkDefault "m";
        global_menu = mkDefault "Ctrl+g";
        shell = mkDefault "s";
        vnc = mkDefault "v";
        refresh = mkDefault "Ctrl+r";
        auto_refresh = mkDefault "a";
        search = mkDefault "/";
        advanced_guest_filter = mkDefault "Ctrl+f";
        help = mkDefault "?";
        quit = mkDefault "q";
      };
    };

    xdg.configFile."pvetui/config.yml".source =
      yamlFormat.generate "pvetui-config" cfg.settings;
  };
}
