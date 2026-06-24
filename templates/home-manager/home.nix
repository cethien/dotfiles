{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    git

    jq
    zoxide
    ripgrep
    fzf
    fd
    eza
    bat

    htop

    lazygit
    yazi
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config.global = {
      hide_env_diff = true;
      warn_timeout = 0;
    };
  };

  programs.neovim = let
    nvim = import ./apps/nvim {inherit pkgs;};
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    inherit (nvim) plugins initLua;
  };

  programs.tmux = {
    enable = true;

    historyLimit = 5000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";

    extraConfig = ''
      ${builtins.readFile ./apps/tmux.conf}
    '';

    sensibleOnTop = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_action 'paste'
          set -g @yank_selection 'clipboard'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-panel-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-processes '"~nvim->nvim *" ssh'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
  };
}
