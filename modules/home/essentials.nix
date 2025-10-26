{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./tmux.nix
    ./ssh.nix
    ./neovim
  ];

  config = {
    programs = {
      tmux.enable = true;
      nvf.enable = mkDefault true;
      ssh.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      curl
      wget
    ];
  };
}
