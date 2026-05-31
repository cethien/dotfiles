{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types sort mapAttrsToList;
  cfg = config.programs.yazi;

  openerType =
    types.coercedTo types.str
    (str: {
      name = str;
      prio = 50;
    })
    (types.submodule {
      options = {
        name = mkOption {type = types.str;};
        prio = mkOption {
          type = types.int;
          default = 50;
        };
      };
    });
in {
  options = {
    programs.yazi.openRulesMerged = mkOption {
      type = types.attrsOf (types.listOf openerType);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    programs.tmux.resurrectPluginProcesses = ["yazi"];

    xdg.mimeApps.defaultApplications."inode/directory" = ["yazi.desktop"];

    wayland.windowManager.hyprland.settings.bind = ["SUPER, e, exec, kitty --class yazi -e yazi"];

    programs.yazi = {
      keymap.mgr.prepend_keymap = let
        ripdrag = "${pkgs.ripdrag}/bin/ripdrag";
      in [
        {
          on = ["T" "s"];
          run = ''shell 'tmux new-session -A -s "$(basename "$PWD" | tr -c "a-zA-Z0-9_" "_" | sed "s/_$//")"' --block'';
          desc = "Tmux: Create/Attach in current DIR";
        }
        {
          on = ["c" "y"];
          run = ''plugin yank-selected-content'';
          desc = "Copy text content only";
        }

        {
          on = ["<C-d>"];
          run = "shell -- ${ripdrag} -banr %s";
          desc = "Drag Files";
        }

        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
        {
          on = "U";
          run = "plugin restore -- --interactive";
          desc = "Restore deleted files/folders (Interactive)";
        }

        {
          on = ["R" "p" "p"];
          run = "plugin sudo -- paste";
          desc = "sudo paste";
        }
        {
          on = ["R" "P"];
          run = "plugin sudo -- paste --force";
          desc = "sudo paste";
        }
        {
          on = ["R" "r"];
          run = "plugin sudo -- rename";
          desc = "sudo rename";
        }
        {
          on = ["R" "p" "l"];
          run = "plugin sudo -- link";
          desc = "sudo link";
        }
        {
          on = ["R" "p" "r"];
          run = "plugin sudo -- link --relative";
          desc = "sudo link relative path";
        }
        {
          on = ["R" "p" "L"];
          run = "plugin sudo -- hardlink";
          desc = "sudo hardlink";
        }
        {
          on = ["R" "a"];
          run = "plugin sudo -- create";
          desc = "sudo create";
        }
        {
          on = ["R" "d"];
          run = "plugin sudo -- remove";
          desc = "sudo trash";
        }
        {
          on = ["R" "D"];
          run = "plugin sudo -- remove --permanently";
          desc = "sudo delete";
        }
        {
          on = ["R" "m"];
          run = "plugin sudo -- chmod";
          desc = "sudo chmod";
        }

        {
          on = ["g" "m"];
          run = "plugin mount";
          desc = "mounts";
        }

        {
          on = ["c" "a" "a"];
          run = "plugin compress";
          desc = "archive files";
        }

        {
          on = "<C-o>";
          run = "shell --confirm '$EDITOR .'";
          desc = "Open the currerent direcory in editor";
        }

        {
          on = "p";
          run = "plugin smart-paste";
        }

        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "chmod";
        }
        {
          on = ["c" "c"];
          run = "plugin ffmpeg-convert";
          desc = "ffmpeg convert";
        }

        {
          on = ["c" "r"];
          run = "plugin rsync";
          desc = "Copy files using rsync";
        }
        {
          on = ["y"];
          run = [
            "yank"
            "copy path"
          ];
          desc = "copy path";
        }
      ];

      plugins = {
        yank-selected-content = ./plugins/yank-selected-content;
        yank-dir-content = ./plugins/yank-dir-content;
        tree-to-clipboard = ./plugins/tree-to-clipboard;
        ffmpeg-convert = ./plugins/ffmpeg-convert;
        inherit
          (pkgs.yaziPlugins)
          mount
          recycle-bin
          git
          githead
          sudo
          chmod
          smart-paste
          jump-to-char
          compress
          rsync
          piper
          ;
      };
      initLua =
        #lua
        ''
          require("git"):setup()
          require("githead"):setup()
        '';
      settings.plugin = {
        prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
            run = "git";
          }
        ];

        prepend_previewers = [
          {
            url = "*.tar*";
            run = ''piper --format=url -- tar tf "$1"'';
          }
          {
            url = "*/";
            run = ''piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
        ];
      };

      extraPackages = with pkgs; [
        jq
        fd
        ripgrep
        fzf
        zoxide
        resvg
        file
        poppler-utils
        ffmpeg
        wl-clipboard

        glow
        ouch
        rsync
        trash-cli
      ];

      settings = {
        open.prepend_rules =
          mapAttrsToList (mime: openers: let
            sortedOpeners = sort (a: b: a.prio < b.prio) openers;
            sortedNames = map (o: o.name) sortedOpeners;
          in {
            inherit mime;
            use = sortedNames;
          })
          cfg.openRulesMerged;
      };

      shellWrapperName = "y";
    };
  };
}
