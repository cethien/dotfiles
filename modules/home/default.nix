{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault;
  desktopEnabled = config.wayland.windowManager.hyprland.enable;
in {
  imports = [
    ./assets
    ./stylix
    ./sops.nix

    ./programs/hyprland
    ./programs/qol
    ./programs/dev
    ./programs/fun.nix
    ./programs/essentials
    ./programs/utils-net.nix
    ./programs/utils
    ./programs/neovim
    ./programs/fastfetch
    ./programs/syncthing.nix
    ./programs/rclone.nix
    ./programs/docker.nix

    ./programs/logitech-peripherals.nix
    ./programs/elgato-stream-deck.nix

    ./programs/browser
    ./programs/discord.nix
    ./programs/imv.nix
    ./programs/spotify.nix
    ./programs/mpv.nix
    ./programs/keepassxc.nix
    ./programs/pim
    ./programs/office.nix

    ./programs/pinta.nix
    ./programs/ocenaudio.nix
    ./programs/inkscape.nix
    ./programs/gimp.nix
    ./programs/drawio.nix
    ./programs/mixxx.nix

    ./programs/rnote.nix
    ./programs/obs-studio.nix
    ./programs/pavucontrol.nix
    ./programs/easyeffects.nix

    ./programs/gaming
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";

  deeznuts = {
    stylix.enable = mkDefault true;
    programs = {
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
      mixxx.enable = mkDefault desktopEnabled;
    };
  };
}
