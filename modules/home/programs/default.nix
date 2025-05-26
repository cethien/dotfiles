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
    gaming.enable = mkEnableOption "Enable gaming related programs";
  };

  imports = [
    ./browser
    ./dev
    ./discord.nix
    ./drawio.nix
    ./easyeffects.nix
    ./fastfetch
    ./fun.nix
    ./gaming/mangohud.nix
    ./gaming/pokemmo.nix
    ./gaming/prismlauncher.nix
    ./gaming/r2modman.nix
    ./gaming/retroarch.nix
    ./gaming/steam.nix
    ./gimp.nix
    ./hyprland
    ./imv.nix
    ./inkscape.nix
    ./keepassxc.nix
    ./mpv.nix
    ./neovim
    ./obs-studio.nix
    ./ocenaudio.nix
    ./pavucontrol.nix
    ./pinta.nix
    ./qol
    ./rnote.nix
    ./essentials
    ./spotify
    ./utils-net.nix
    ./utils.nix
  ];

  config.deeznuts.programs = {
    essentials.enable = mkDefault true;
    utils.enable = mkDefault true;
    qol.enable = mkDefault true;
    net.enable = mkDefault true;
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

    pinta.enable = mkDefault cfg.desktop.enable;
    gimp.enable = mkDefault cfg.desktop.enable;
    inkscape.enable = mkDefault cfg.desktop.enable;
    drawio.enable = mkDefault cfg.desktop.enable;
    ocenaudio.enable = mkDefault cfg.desktop.enable;

    mangohud.enable = mkDefault cfg.gaming.enable;
    steam.enable = mkDefault cfg.gaming.enable;
    r2modman.enable = mkDefault cfg.gaming.enable;
    retroarch.enable = mkDefault cfg.gaming.enable;
    prismlauncher.enable = mkDefault cfg.gaming.enable;
    pokemmo.enable = mkDefault cfg.gaming.enable;
  };
}
