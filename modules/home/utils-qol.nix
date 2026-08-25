{
  lib,
  config,
  pkgs,
  pkgs-unstable,
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
        action = "new-window -an qalc qalc";
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
