{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      sshfs
    ];

    programs.ssh = {
      enableDefaultConfig = false;
      settings = {
        "Host *" = {
          Compression = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/sockets/%r@%h:%p";
          ControlPersist = "10m";

          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;

          HashKnownHosts = "yes";
        };
      };
    };

    home.file.".ssh/sockets/.keep".text = "";

    programs.tmux.resurrectPluginProcesses = ["ssh"];
  };
}
