{ lib, config, ... }:

{
  imports = [
    ./shell
    ./networking
    ./dev

    ./misc

    ./bat
    ./bottom
    ./direnv
    ./duf
    ./eza
    ./fastfetch
    ./fd
    ./ffmpeg
    ./fzf
    ./neovim
    ./poppler
    ./procs
    ./ripgrep
    ./ssh
    ./tmux
    ./yazi
    ./zoxide
  ];

  options.deeznuts.cli.enable = lib.mkEnableOption "Enable all cli tools";

  config = lib.mkIf config.deeznuts.cli.enable {
    deeznuts.cli = {
      shell =
        {
          aliases.enable = true;
          oh-my-posh.enable = true;
          hushlogin.enable = true;

          bash.enable = true;
        };

      dev.enable = true;
      networking.enable = true;

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
      neovim.enable = true;
      poppler.enable = true;
      procs.enable = true;
      ripgrep.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      zoxide.enable = true;
    };
  };
}
