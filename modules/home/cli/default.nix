{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli;
in
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
    ./scripts
    ./ssh
    ./tmux
    ./yazi
    ./zoxide
  ];

  options.deeznuts.cli = {
    enable = mkEnableOption "Enable all cli tools";
  };

  config = mkIf cfg.enable {
    deeznuts.cli = {
      shell =
        {
          aliases.enable = true;
          oh-my-posh.enable = true;
          hushlogin.enable = true;

          bash.enable = true;
        };

      scripts.enable = true;

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
