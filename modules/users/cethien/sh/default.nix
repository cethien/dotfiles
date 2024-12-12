{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./bash.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./fastfetch.nix

    ./gh.nix
    ./lazydocker.nix
  ];

  programs = {
    ssh.enable = true;
    
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    fzf.enable = true;
  };

  home.packages = with pkgs; [
    curl
    wget
    zip
    unzip

    procs
    duf
  ];
}
