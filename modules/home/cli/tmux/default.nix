{ lib, config, pkgs, ... }:

{
  options.cli.tmux.enable = lib.mkEnableOption "Enable tmux";

  config = lib.mkIf config.cli.tmux.enable {
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
