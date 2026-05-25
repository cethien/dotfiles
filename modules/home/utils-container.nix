{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.container-tools = {
    enable = lib.mkEnableOption "enable tools for docker, k8s, podman";
  };

  config = let
    containers = config.programs.container-tools.enable;
  in
    lib.mkIf containers {
      home.packages = with pkgs; [podman-compose k3d kubectl];

      services.podman.enable = true;
      programs.lazydocker.enable = true;
      home.shellAliases.lzd = "lazydocker";

      programs.tmux.resurrectPluginProcesses = ["lazydocker"];
    };
}
