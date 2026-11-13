{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.utils-qol;

  markdownOpeners = [
    {
      name = "glow";
      prio = 10;
    }
    {
      name = "edit";
      prio = 20;
    }
    {
      name = "vivify";
      prio = 40;
    }
    {
      name = "reveal";
      prio = 90;
    }
  ];
  htmlOpeners = [
    {
      name = "lynx";
      prio = 10;
    }
    {
      name = "edit";
      prio = 20;
    }
    {
      name = "open";
      prio = 60;
    }
    {
      name = "reveal";
      prio = 90;
    }
  ];
  epubOpeners = [
    {
      name = "epr";
      prio = 10;
    }
    {
      name = "bk";
      prio = 20;
    }
    {
      name = "open";
      prio = 60;
    }
    {
      name = "reveal";
      prio = 90;
    }
  ];

in {
  options.programs.utils-qol.enable = lib.mkEnableOption "qol utils";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-utils-qol" =
        # lua
        ''
          Modal("qalc", { binds = {
          	"SUPER + COMMA",
          	"XF86Calculator",
          } })

          Modal("bluetui", { binds = {
          	"SUPER + B",
          	"XF86Bluetooth",
          } })
        '';
    };

    programs.tmux.keybindings = [
      {
        key = "-";
        action = "new-window -an qalc qalc";
      }
    ];

    programs.yazi = {
      openRulesMerged = {
        "application/iso9660-image" = [
          "caligula"
          {
            name = "open";
            prio = 60;
          }
          {
            name = "reveal";
            prio = 90;
          }
        ];
        "text/markdown" = markdownOpeners;
        "text/x-markdown" = markdownOpeners;
        "text/html" = htmlOpeners;
        "application/xhtml+xml" = htmlOpeners;
        "application/epub+zip" = epubOpeners;
      };
      openUrlRulesMerged = {
        "*.{md,markdown}" = markdownOpeners;
        "*.{htm,html,xhtml}" = htmlOpeners;
        "*.epub" = epubOpeners;
      };
      settings.opener = {
        caligula = [
          {
            run = ''caligula burn %s1 --root=always -f -z=none -s=skip'';
            desc = "Burn disk image (Caligula)";
            block = true;
            for = "unix";
          }
        ];
        glow = [
          {
            run = ''glow -p %s1'';
            desc = "Read Markdown (glow)";
            block = true;
            for = "unix";
          }
        ];
        vivify = [
          {
            run = ''viv %s1'';
            desc = "Live Markdown viewer (Vivify)";
            block = true;
            for = "unix";
          }
        ];
        lynx = [
          {
            run = ''lynx %s1'';
            desc = "Read HTML (Lynx)";
            block = true;
            for = "unix";
          }
        ];
        epr = [
          {
            run = ''epr %s1'';
            desc = "Read EPUB (epr)";
            block = true;
            for = "unix";
          }
        ];
        bk = [
          {
            run = ''bk %s1'';
            desc = "Read EPUB (bk)";
            block = true;
            for = "unix";
          }
        ];
      };
    };

    home.packages = with pkgs-unstable; [
      termshot

      systemctl-tui
      bluetui

      caligula

      # slides
      slides
      marp-cli

      # markdown reader
      glow
      vivify

      # ebooks
      epr
      bk

      poppler-utils # pdf stuff
      lynx # term browser
    ];

    programs = {
      zoxide.package = pkgs-unstable.zoxide;
      zoxide.options = ["--cmd cd"];

      ripgrep.package = pkgs-unstable.ripgrep;
      ripgrep.arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];

      eza = {
        package = pkgs-unstable.eza;
        git = true;
        icons = "always";
        extraOptions = [
          "--group-directories-first"
        ];
      };

      bat.package = pkgs-unstable.bat;
      bat.config = {
        style = "plain";
      };

      less.package = pkgs-unstable.less;
      less.options = {
        RAW-CONTROL-CHARS = true;
        quit-if-one-screen = true;
        ignore-case = true;
        no-init = true;
      };
    };

    home.sessionVariables = {
      PAGER = "less";
    };

    programs.tmux.resurrectPluginProcesses = ["systemctl-tui"];

    home.shellAliases = {
      sysz = "systemctl-tui";

      cdd = "cd ~/Downloads";
      cdc = "cd ~/.config";
      mkdir = "mkdir -p";
      cp = "cp -i";

      cat = "bat";
      tree = "eza -T";
      ps = "${pkgs-unstable.procs}/bin/procs";
      df = "${pkgs-unstable.duf}/bin/duf";
      du = "${pkgs-unstable.gdu}/bin/gdu";

      reload = "source ~/.$(basename $SHELL)rc && clear";
    };
  };
}
