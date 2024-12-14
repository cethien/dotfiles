{ lib, config, ... }:

{
  options.gaming.opengl.enable = lib.mkEnableOption "Enable OpenGL";

  config = lib.mkIf config.gaming.opengl.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}