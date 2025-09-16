{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.deeznuts.programs.dev.containers.enable {
    home.packages = with pkgs; [
      podman-compose
      k3d
    ];
    services.podman.enable = true;
    programs.lazydocker.enable = true;
    home.shellAliases.lzd = "lazydocker";
  };
}
