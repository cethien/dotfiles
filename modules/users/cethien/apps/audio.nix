{ lib, config, pkgs, ... }:

{
  options.user.apps.audio.enable = lib.mkEnableOption "Enable audio applications (qpwgraph, carla)";

  config = lib.mkIf config.user.apps.audio.enable {
    home.packages = with pkgs; [
      qpwgraph
      carla
    ];
  };
}