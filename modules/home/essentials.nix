{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./tmux.nix
    ./neovim
  ];

  config = {
    programs = {
      tmux.enable = true;
      nvf.enable = mkDefault true;
      ssh.enable = mkDefault true;
      ssh = {
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = mkDefault {
            compression = true;
            forwardAgent = true;
            hashKnownHosts = true;
          };
        };
      };
      tmux.resurrectPluginProcesses = ["ssh"];
    };

    home.packages = with pkgs; [
      curl
      wget
    ];
  };
}
