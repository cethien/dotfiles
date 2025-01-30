{ lib, config, ... }:
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.steam = {
    enable = lib.mkEnableOption "Enable Steam";
  };

  config = lib.mkIf config.deeznuts.programs.steam.enable {
    # dummy option, steam must be installed as a nixos option
  };
}
