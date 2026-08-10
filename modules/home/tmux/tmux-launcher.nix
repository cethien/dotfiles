{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.programs.tmux.launcher;

  entryModule = types.submodule {
    options = {
      icon = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional Nerd Font icon (menu display only)";
      };
      name = mkOption {
        type = types.str;
        description = "Entry name (used in menu and as pure tmux window title)";
      };
      hold = mkOption {
        type = types.bool;
        default = false;
        description = "Keep window open after execution until Ctrl+C is pressed";
      };
      exec = mkOption {
        type = types.str;
        description = "Command to execute";
      };
      preview = mkOption {
        type = types.nullOr types.str;
        default = "echo ''";
        description = "Preview command for fzf";
      };
    };
  };

  tomlFormat = pkgs.formats.toml {};

  tmuxLauncherPreviewPkg = pkgs.writers.writePython3Bin "tmux-launcher-preview" {
    libraries = [pkgs.python3Packages.colorama];
    makeWrapperArgs = [
      "--prefix PATH : ${lib.makeBinPath (with pkgs; [
        openssh
        gawk
        gnugrep
        coreutils
        procps
      ])}"
    ];
  } (builtins.readFile ./tmux-launcher-preview.py);

  fzfLauncherPkg = config.lib.deeznuts.mkArgcBashBin {
    src = ./tmux-launcher.sh;
    extraRuntimeDeps = with pkgs; [
      fzf
      yq-go
      openssh
      tmux
      tmuxLauncherPreviewPkg
    ];
  };
in {
  options.programs.tmux.launcher = {
    entries = mkOption {
      type = types.listOf entryModule;
      default = [];
      description = "custom entries for fzf tmux launcher";
    };
  };

  config = {
    xdg.configFile."tmux/launcher.toml".source = tomlFormat.generate "tmux-launcher-config.toml" {
      inherit (cfg) entries;
    };

    home.packages = [
      fzfLauncherPkg
    ];

    programs.tmux.keybindings = [
      {
        key = "o";
        action = "display-popup -w 90% -h 80% -E '${fzfLauncherPkg}/bin/tmux-launcher'";
      }
    ];
  };
}
