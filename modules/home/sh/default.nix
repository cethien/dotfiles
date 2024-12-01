{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./bash.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
  ];

  programs = {
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    fzf.enable = true;
    ssh.enable = true;
  };

  home.packages = with pkgs; [
      procs
      duf
      curl
      wget
      zip
      unzip
  ];
}