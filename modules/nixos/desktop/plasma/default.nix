{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.plasma;
in
{
  options.deeznuts.desktop.plasma = {
    enable = mkEnableOption "Enable plasma desktop";
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        # package = pkgs.kdePackages.sddm;
      };

      autoLogin =
        let
          desktopCfg = config.deeznuts.desktop;
        in
        {
          enable = desktopCfg.autoLogin.enable;
          user = desktopCfg.autoLogin.user;
        };
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs; [
      khelpcenter
      kwalletmanager
    ];
    environment.systemPackages = with pkgs.kdePackages; [
      dragon # video player
      kcolorchooser
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
