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
    wayland.windowManager.hyprland.modals."qalc".binds = [
      "SUPER, COMMA"
      ", XF86Calculator"
    ];

    wayland.windowManager.hyprland.modals."bluetui".binds = [
      "SUPER, B"
      ", XF86Bluetooth"
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

    home.packages = with pkgs; [
      up
      libqalculate

      (pkgs.writeShellScriptBin "termshot" ''
        mkdir -p ~/Pictures
        FILENAME="${config.home.homeDirectory}/Pictures/termshot_$(date +%Y%m%d_%H%M%S).png"
        command ${pkgs.termshot}/bin/termshot -f "$FILENAME" -c --no-decoration -- "$@"
        if [ -f "$FILENAME" ]; then
          command ${pkgs.wl-clipboard}/bin/wl-copy < "$FILENAME"
          echo "Saved to $FILENAME and Clipboard"
        fi
      '')

      sysz
      bluetui

      caligula

      # slides
      slides
      marp-cli

      # markdown reader
      glow
      mdcat

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

      fzf = {
        defaultCommand = "fd --type f";
        defaultOptions = ["--layout=reverse"];

        fileWidgetCommand = "fd --type f";
        fileWidgetOptions = [
          "--preview 'bat {} --color=always --plain'"
        ];

        changeDirWidgetCommand = "fd --type d";
        changeDirWidgetOptions = [
          "--preview 'eza {} -1a --icons=always --color=always'"
        ];
      };

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

    home.shellAliases = {
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
