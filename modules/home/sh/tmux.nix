{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      tmux-fzf
      resurrect
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
}
