{
  imports = [ ../../modules/home ];

  cli = {
    shell.bash.enable = true;

    fzf.enable = true;
    neovim.enable = true;
    bottom.enable = true;
    duf.enable = true;
    procs.enable = true;
    yazi.enable = true;
  };
}
