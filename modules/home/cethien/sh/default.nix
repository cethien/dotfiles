{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./bash.nix
    ./bat.nix
    ./duf.nix
    ./eza.nix
    ./fastfetch.nix
    ./fd.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./lazydocker.nix
    ./neovim.nix
    ./oh-my-posh.nix
    ./procs.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tmux.nix
    ./zoxide.nix
  ];
}
