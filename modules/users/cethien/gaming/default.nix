{ lib, config, ... }:

{
  options.user.gaming.enable = lib.mkEnableOption "Enable gaming";

  imports = [
    ./prism-launcher.nix
    ./r2modman.nix
    ./retroarch.nix

    ./lutris.nix

    ./protonge.nix
    ./mangohud.nix
  ];

  config = lib.mkIf config.user.gaming.enable {
    user.gaming.prism-launcher.enable = true;
    user.gaming.r2modman.enable = true;
    user.gaming.retroarch.enable = true;

    user.gaming.lutris.enable = true;

    user.gaming.mangohud.enable = true;
    user.gaming.protonge.enable = true;
  };
}
