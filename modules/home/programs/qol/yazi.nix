{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.programs.yazi = mkIf config.programs.yazi.enable {
    plugins = {
      inherit
        (pkgs.yaziPlugins)
        mount
        sudo
        chmod
        smart-paste
        git
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
    keymap = {
      manager.prepend_keymap = [
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
          on = ["c" "m"];
          run = "plugin chmod";
        }
      ];
    };
  };
}
