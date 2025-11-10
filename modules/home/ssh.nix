{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkMerge;
in {
  options.programs.ssh.matchBlocksExtra = mkOption {
    type = types.attrsOf types.anything;
    default = {};
    description = ''
      Extra SSH match blocks to merge with the default SSH configuration.
      Example:
        {
          "soft-serve" = {
            Host = "soft-serve";
            HostName = "192.168.1.42";
            User = "cethien";
            IdentityFile = "~/.ssh/id_ed25519_personal";
          };
        }
    '';
  };

  config = {
    home.packages = with pkgs; [sshs];
    programs.ssh = {
      enableDefaultConfig = false;
      matchBlocks = mkMerge [
        {
          "*" = {
            compression = true;
            forwardAgent = true;
            hashKnownHosts = true;
          };
        }
        config.programs.ssh.matchBlocksExtra
      ];
    };

    programs.tmux.resurrectPluginProcesses = ["ssh"];
  };
}
