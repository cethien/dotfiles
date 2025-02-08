{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.tmux;
in
{
  options.deeznuts.programs.tmux = {
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
        # resurrect
        # continuum
        better-mouse-mode
        prefix-highlight
      ];

      extraConfig = ''
        set -g mouse on
      '';
    };

    home.shellAliases = {
      tm = "tmux";
      tmls = "tmux ls";
      tma = "tmux attach";
      tmas = "tmux attach -t";
      tmk = "tmux kill-session -t";
    };
  };
}
