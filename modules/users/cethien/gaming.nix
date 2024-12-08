{ lib, config, pkgs,... }:

{
  options.user.gaming.enable = lib.mkEnableOption "Enable gaming";

  config = lib.mkIf config.user.gaming.enable {
    programs = {
      mangohud = {
        enable = true;
        settings = {
          fps_only = true;
        };
      };
    };

    home.packages = with pkgs; [
      prismlauncher
    ];
  };

}