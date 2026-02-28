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
      keymap.mgr.prepend_keymap = [
        {
          on = ["<C-d>"];
          run = "shell -- ripdrag -banr %s";
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
          on = "y";
          run = [
            "shell -- for path in $@; do echo file://$path; done | wl-copy -t text/uri-list"
            "yank"
          ];
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
      ];

      plugins = {
        ffmpeg-convert = ./yazi-plugins/ffmpeg-convert;
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

      extraPackages = with pkgs; [
        glow
        ouch
        ffmpeg
        rsync
        ripdrag
        trash-cli
      ];

      settings.plugin = {
        prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
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

      settings = {
        opener = {
          imv = [
            {
              run = ''imv-dir "$@"'';
              desc = "imv";
              for = "unix";
            }
          ];
          gimp = [
            {
              run = ''gimp "$@"'';
              desc = "GIMP";
              orphan = true;
              for = "unix";
            }
          ];
          pinta = [
            {
              run = ''pinta "$@"'';
              desc = "Pinta";
              orphan = true;
              for = "unix";
            }
          ];

          inkscape = [
            {
              run = ''inkscape "$@"'';
              desc = "Inkscape";
              orphan = true;
              for = "unix";
            }
          ];

          mpv = [
            {
              run = ''mpv "$@"'';
              desc = "mpv";
              for = "unix";
            }
          ];

          ocenaudio = [
            {
              run = ''ocenaudio "$@"'';
              desc = "ocenaudio";
              for = "unix";
            }
          ];
        };

        open = {
          prepend_rules = [
            {
              mime = "audio/*";
              use = ["mpv" "ocenaudio"];
            }
            {
              mime = "image/svg+xml";
              use = ["imv" "inkscape"];
            }
            {
              mime = "image/*";
              use = ["imv" "pinta" "gimp"];
            }
          ];
        };
      };

      shellWrapperName = "y";
    };
  };
}
