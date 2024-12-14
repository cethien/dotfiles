{ lib, config, ... }:

{
  options.audio.noisetorch.enable = lib.mkEnableOption "Enable noisetorch";

  config = lib.mkIf config.audio.noisetorch.enable {
    programs.noisetorch.enable = true;
  };
}