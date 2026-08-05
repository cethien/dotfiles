{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfg = config.programs.fzf-launcher;

  toolModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "cmd name";
      };
      exec = mkOption {
        type = types.str;
        description = "exec cmd";
      };
      preview = mkOption {
        type = types.nullOr types.str;
        default = "echo ''";
        description = "preview command";
      };
    };
  };

  tomlFormat = pkgs.formats.toml {};

  fzfLauncherPkg = config.lib.deeznuts.mkArgcBashBin {
    src = ./fzf-launcher.sh;
    extraRuntimeDeps = with pkgs; [
      fzf
      yq-go
      openssh
      bat
      gawk
      gnused
    ];
  };

  fzf-launcher-wrapper = pkgs.writeShellScriptBin "fzf-launcher-wrapper" ''
    cmd=$(fzf-launcher --stdout)
    if [ -n "$cmd" ]; then
      tmux new-window "$cmd"
    fi
  '';
in {
  options.programs.fzf-launcher = {
    enable = mkEnableOption "fzf launcher";

    tools = mkOption {
      type = types.listOf toolModule;
      default = [];
      description = "custom tools";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."fzf-launcher/config.toml".source = tomlFormat.generate "fzf-launcher-config.toml" {
      inherit (cfg) tools;
    };

    home.packages = [
      fzfLauncherPkg
    ];

    programs.tmux.keybindings = [
      {
        key = "o";
        action = ''display-popup -w 80% -h 75% -E "${fzf-launcher-wrapper}/bin/fzf-launcher-wrapper"'';
      }
    ];
  };
}
