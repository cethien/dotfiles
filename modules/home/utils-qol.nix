{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.utils-qol;
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
        action = "new-window -n qalc qalc";
      }
    ];

    programs.yazi = {
      openRulesMerged = {
        "application/iso9660-image" = ["caligula"];
      };
      settings.opener = {
        caligula = [
          {
            run = ''caligula burn "$@" --root=always -f -z=none -s=skip'';
            desc = "caligula";
            block = true;
            for = "unix";
          }
        ];
      };
    };

    home.packages = with pkgs.unstable; [
      libqalculate

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
      zoxide.options = ["--cmd cd"];

      ripgrep.arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];

      eza = {
        git = true;
        icons = "always";
        extraOptions = [
          "--group-directories-first"
        ];
      };

      bat.config = {
        pager = "${pkgs.nvimpager}/bin/nvimpager";
        style = "plain";
      };
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
      ps = "${pkgs.procs}/bin/procs";
      df = "${pkgs.duf}/bin/duf";
      du = "${pkgs.gdu}/bin/gdu";

      reload = "source ~/.$(basename $SHELL)rc && clear";
    };
  };
}
