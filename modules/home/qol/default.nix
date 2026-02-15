{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.programs.qol;
in {
  imports = [
    ./bottom.nix
    ./yazi.nix
    ./oh-my-posh.nix
  ];

  options.programs.qol = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, COMMA, exec, ${
        (pkgs.cethien.mkHyprLaunchBin' "qalc").bin
      }"
    ];

    home.packages = with pkgs; [
      up

      libqalculate

      # markdown reader
      glow
      mdcat

      # ebooks
      epr
      bk

      termshot
      slides
      sysz
    ];

    programs = {
      oh-my-posh.enable = true;

      zoxide.enable = true;
      zoxide.options = ["--cmd cd"];

      ripgrep.enable = true;
      ripgrep.arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];

      tealdeer.enable = true;

      fzf.enable = true;
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

      fd.enable = true;

      eza.enable = true;
      eza = {
        git = true;
        icons = "always";
        extraOptions = [
          "--group-directories-first"
        ];
      };

      bat.enable = true;
      bat.config = {
        pager = "${pkgs.nvimpager}/bin/nvimpager";
        style = "plain";
      };

      bottom.enable = true;
      yazi.enable = true;
    };

    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./fastfetch-settings.json));
    };

    home.shellAliases = {
      cdd = "cd ~/Downloads";
      cdc = "cd ~/.config";
      mkdir = "mkdir -p";
      cp = "cp -i";

      cat = "bat";
      tree = "eza -T";
      ff = "fastfetch";
      ps = "${pkgs.procs}/bin/procs";
      df = "${pkgs.duf}/bin/duf";
      du = "${pkgs.gdu}/bin/gdu";

      reload = "source ~/.$(basename $SHELL)rc && clear";
    };

    home.file.".config/fastfetch/logo.png".source = ./bernd_pixel.png;
    home.file."${config.home.homeDirectory}/.hushlogin".text = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  };
}
