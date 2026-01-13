{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.yazi.enable {
    programs.tmux.resurrectPluginProcesses = ["yazi"];

    xdg.mimeApps.defaultApplications."inode/directory" = ["yazi.desktop"];
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, e, exec, $terminal --class yazi -e yazi"
      ];
    };

    programs.yazi = {
      extraPackages = with pkgs; [
        glow
        ouch
      ];

      plugins = {
        inherit
          (pkgs.yaziPlugins)
          mount
          sudo
          chmod
          smart-paste
          git
          restore
          glow
          jump-to-char
          compress
          ;
      };
      settings.plugin.prepend_fetchers = [
        {
          id = "git";
          name = "";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
      initLua = ''
        th.git = th.git or {}

        th.git.modified_sign = "M"
        th.git.added_sign = "A"
        th.git.deleted_sign = "D"
        th.git.untracked_sign = "A"

        require("git"):setup()
      '';
      keymap.mgr.prepend_keymap = [
        {
          on = "!";
          run = "shell '$SHELL' --block";
        }
        {
          on = "y";
          run = [
            "shell -- for path in $@; do echo file://$path; done | wl-copy -t text/uri-list"
            "yank"
          ];
        }
        {
          on = "M";
          run = "plugin mount";
        }
        {
          on = "p";
          run = "plugin smart-paste";
        }
        {
          on = ["u" "m"];
          run = "plugin chmod";
        }
      ];
    };
  };
}
