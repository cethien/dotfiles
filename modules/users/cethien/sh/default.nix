{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./bash.nix
    ./ssh.nix
    ./git.nix
    ./tmux.nix
    ./neovim.nix
    
    ./oh-my-posh.nix
    ./fastfetch.nix

    ./gh.nix
    ./lazydocker.nix
  ];

  programs = {  
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
