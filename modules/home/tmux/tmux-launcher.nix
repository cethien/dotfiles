{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.tmux.launcher;
  tomlFormat = pkgs.formats.toml {};
in {
  options.programs.tmux.launcher = {
    settings = lib.mkOption {
      type = tomlFormat.type;
      default = {};
      description = "Settings for tmux-launcher, generated into launcher.toml";
    };
  };

  config = {
    xdg.configFile."tmux/launcher.toml".source = tomlFormat.generate "tmux-launcher-config.toml" cfg.settings;

    home.packages = [
      pkgs.tmux-launcher
    ];

    programs.tmux.keybindings = [
      {
        key = "Space";
        action = "display-popup -w 90% -h 80% -E '${pkgs.tmux-launcher}/bin/tmux-launcher'";
      }
    ];
  };
}
