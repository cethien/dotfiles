{ lib, config, ... }:

{
  imports = [
    ./shell
    ./networking

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
    ./gh
    ./git
    ./jq
    ./lazydocker
    ./lazygit
    ./neovim
    ./poppler
    ./procs
    ./ripgrep
    ./ssh
    ./tmux
    ./yazi
    ./zoxide
  ];

  options.cli.enable = lib.mkEnableOption "Enable all cli tools";

  config = lib.mkIf config.cli.enable {
    cli = {
      shell =
        {
          aliases.enable = true;
          oh-my-posh.enable = true;
          bash.enable = true;
        };

      networking = {
        nmap.enable = true;
        termshark.enable = true;
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
  };
}
