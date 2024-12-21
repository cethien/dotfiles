{
  imports = [ ../../modules/home ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  catppuccin.enable = true;

  cli = {
    shell =
      {
        aliases.enable = true;
        oh-my-posh.enable = true;
        bash.enable = true;
      };

    misc.enable = true;

    bat.enable = true;
    bottom.enable = true;
    direnv.enable = true;
    duf.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    ffmpeg.enable = true;
    fzf.enable = true;
    gh.enable = true;
    git = {
      enable = true;
    };
    jq.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;
    neovim.enable = true;
    poppler.enable = true;
    procs.enable = true;
    ripgrep.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };

}
