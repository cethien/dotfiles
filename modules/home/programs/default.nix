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
    gaming.enable = mkEnableOption "Enable gaming related programs";
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

    ./hyprland

    ./browser
    ./discord.nix
    ./gaming/mangohud.nix
    ./gaming/pokemmo.nix
    ./gaming/prismlauncher.nix
    ./gaming/r2modman.nix
    ./gaming/retroarch.nix
    ./gaming/steam.nix
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
    browser.zen-browser.enable = mkDefault cfg.desktop.enable;
    discord.enable = mkDefault cfg.desktop.enable;
    spotify.enable = mkDefault cfg.desktop.enable;
    keepassxc.enable = mkDefault cfg.desktop.enable;

    pinta.enable = mkDefault cfg.media-tools.enable;
    gimp.enable = mkDefault cfg.media-tools.enable;
    inkscape.enable = mkDefault cfg.media-tools.enable;
    drawio.enable = mkDefault cfg.media-tools.enable;
    ocenaudio.enable = mkDefault cfg.media-tools.enable;

    mangohud.enable = mkDefault cfg.gaming.enable;
    steam.enable = mkDefault cfg.gaming.enable;
    r2modman.enable = mkDefault cfg.gaming.enable;
    retroarch.enable = mkDefault cfg.gaming.enable;
    prismlauncher.enable = mkDefault cfg.gaming.enable;
    pokemmo.enable = mkDefault cfg.gaming.enable;
  };
}
