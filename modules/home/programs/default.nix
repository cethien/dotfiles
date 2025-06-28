{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault;
  desktopEnabled = config.wayland.windowManager.hyprland.enable;
in {
  imports = [
    ./qol
    ./dev
    ./fun.nix
    ./essentials
    ./utils-net.nix
    ./utils
    ./neovim
    ./fastfetch
    ./syncthing.nix
    ./rclone.nix
    ./docker.nix

    ./hyprland

    ./logitech-peripherals.nix
    ./elgato-stream-deck.nix

    ./browser
    ./discord.nix
    ./imv.nix
    ./spotify.nix
    ./mpv.nix
    ./keepassxc.nix
    ./pim
    ./office.nix

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
    docker.enable = mkDefault true;
    neovim.enable = mkDefault true;
    fun.enable = mkDefault true;
    fastfetch.enable = mkDefault true;

    keepassxc.enable = mkDefault desktopEnabled;
    keepassxc.hyprland.autostart.enable = mkDefault desktopEnabled;
    pavucontrol.enable = mkDefault desktopEnabled;
    easyeffects.enable = mkDefault desktopEnabled;
    browser = {
      zen-browser.enable = mkDefault desktopEnabled;
      zen-browser.hyprland.autostart.enable = mkDefault desktopEnabled;
      firefox.enable = mkDefault desktopEnabled;

      defaultBrowser = "zen-beta";
    };
    discord.enable = mkDefault desktopEnabled;
    spotify.enable = mkDefault desktopEnabled;
    spotify.hyprland.autostart.enable = mkDefault desktopEnabled;

    office.enable = mkDefault desktopEnabled;
    pinta.enable = mkDefault desktopEnabled;
    gimp.enable = mkDefault desktopEnabled;
    inkscape.enable = mkDefault desktopEnabled;
    drawio.enable = mkDefault desktopEnabled;
    ocenaudio.enable = mkDefault desktopEnabled;
  };
}
