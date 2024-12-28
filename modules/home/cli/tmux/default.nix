{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.tmux;
in
{
  options.deeznuts.cli.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        open
        tmux-fzf
        resurrect
        continuum
        better-mouse-mode
        prefix-highlight
      ];

      extraConfig = ''
        set -g mouse on
      '';
    };

    home.shellAliases = {
      tm = "tmux";
      tma = "tmux attach";
      tmas = "tmux attach -t";
      tml = "tmux ls";
      tmn = "tmux new";
    };
  };
}
