{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault;
  cfg = config.deeznuts.programs;
in {
  options.deeznuts.programs = {
    desktop.enable = mkEnableOption "Enable basic desktop programs";
    media-tools.enable = mkEnableOption "Enable programs for media creation";
  };

  imports = [
    ./qol
    ./dev
    ./fun
    ./essentials
    ./utils-net.nix
    ./utils
    ./neovim
    ./fastfetch
    ./syncthing.nix

    ./hyprland

    ./browser
    ./discord.nix
    ./imv.nix
    ./spotify
    ./mpv.nix
    ./keepassxc.nix

    ./pinta.nix
    ./ocenaudio.nix
    ./inkscape.nix
    ./gimp.nix
    ./drawio.nix

    ./rnote.nix
    ./obs-studio.nix
    ./pavucontrol.nix
    ./easyeffects.nix

    ./gaming
  ];

  config.deeznuts.programs = {
    essentials.enable = mkDefault true;
    utils.enable = mkDefault true;
    net.enable = mkDefault true;
    qol.enable = mkDefault true;
    dev.enable = mkDefault true;
    neovim.enable = mkDefault true;
    fun.enable = mkDefault true;
    fastfetch.enable = mkDefault true;

    pavucontrol.enable = mkDefault cfg.desktop.enable;
    easyeffects.enable = mkDefault cfg.desktop.enable;
    browser = {
      firefox.enable = mkDefault cfg.desktop.enable;
      zen-browser.enable = mkDefault cfg.desktop.enable;
      zen-browser.hyprland.autostart.enable = mkDefault cfg.desktop.enable;

      xmimeDefault = "zen-beta.desktop";
    };
    discord.enable = mkDefault cfg.desktop.enable;
    spotify.enable = mkDefault cfg.desktop.enable;
    spotify.hyprland.autostart.enable = mkDefault cfg.desktop.enable;
    keepassxc.enable = mkDefault cfg.desktop.enable;
    keepassxc.hyprland.autostart.enable = mkDefault cfg.desktop.enable;

    pinta.enable = mkDefault cfg.media-tools.enable;
    gimp.enable = mkDefault cfg.media-tools.enable;
    inkscape.enable = mkDefault cfg.media-tools.enable;
    drawio.enable = mkDefault cfg.media-tools.enable;
    ocenaudio.enable = mkDefault cfg.media-tools.enable;
  };
}
