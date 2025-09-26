{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf mkBefore;
  cfg = config.programs.qol;
in {
  imports = [
    ./bottom.nix
    ./yazi.nix
  ];

  options.programs.qol = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      procs
      duf
      gdu
      tealdeer

      # markdown reader
      glow
      mdcat

      # ebooks
      epr
      bk

      termshot
      slides

      (writeShellScriptBin "update" (builtins.readFile ./scripts/update.sh))
      (writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./scripts/cleanup.sh))
      (writeShellScriptBin "init" (builtins.readFile ./scripts/init.sh))
    ];

    programs = {
      yazi.enable = true;

      zoxide.enable = true;
      zoxide.options = ["--cmd cd"];
      ripgrep.enable = true;
      ripgrep.arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
      fzf.enable = true;
      fzf = {
        defaultCommand = "fd --type f";
        fileWidgetCommand = "fd --type f";
        changeDirWidgetCommand = "fd --type d";
      };
      fd.enable = true;
      eza.enable = true;
      bat.enable = true;

      bottom.enable = true;

      oh-my-posh.enable = true;
      oh-my-posh.settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh/themes/cethien.omp.json)
      );

      bash.enable = true;
      bash.initExtra = mkBefore ''
        source ${pkgs.blesh}/share/blesh/ble.sh
      '';
    };

    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./fastfetch-settings.json));
    };

    home.shellAliases = {
      ff = "fastfetch";
      cp = "cp -i";

      cdc = "cd ~/.config";
      cdd = "cd ~/Downloads";

      mkdir = "mkdir -p";

      ps = "procs";

      fdf = "fd --type f";
      fdd = "fd --type d";

      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -1a --icons --group-directories-first --git";
      tree = "eza -T --icons";

      df = "duf";
      du = "duf";

      cat = "bat -p";

      reload = "source ~/.bashrc && clear";
    };

    home.file.".config/fastfetch/logo.png".source = ./bernd_pixel.png;
    home.file."${config.home.homeDirectory}/.hushlogin".text = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  };
}
