{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      sshfs
      (writeShellScriptBin "ssh-scan-from-config" (builtins.readFile ./ssh-scan-from-config.sh))
    ];

    programs.ssh = {
      enableDefaultConfig = false;
      settings = {
        "Host *" = {
          Compression = "yes";
          HashKnownHosts = "yes";
        };
      };
    };

    programs.tmux.resurrectPluginProcesses = ["ssh"];
  };
}
