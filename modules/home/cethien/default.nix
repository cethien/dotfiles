{ system, config, ... }:

{
  imports = [
    ./apps
    ./customization
    ./dev
    ./gaming
    ./sh
    ./user-scripts

    ./hushlogin.nix
  ];

  user.apps = {
    audio.enable = !system.profile.isWSL;
    flameshot.enable = !system.profile.isWSL;
    firefox.enable = !system.profile.isWSL;
    spotify.enable = !system.profile.isWSL;
    vscode.enable = !system.profile.isWSL;
    keepassxc.enable = !system.profile.isWSL;
    drawio.enable = !system.profile.isWSL;

    rnote.enable = system.profile.isSurface;

    discord.enable = system.profile.isHomePC;
    ocenaudio.enable = system.profile.isHomePC;
    inkscape.enable = system.profile.isHomePC;
    obs-studio.enable = system.profile.isHomePC;
  };

  user.customization = {
    catppuccin.enable = true;

    gnome = {
      extensions.enable = !system.profile.isWSL;
      keybindings.enable = !system.profile.isWSL;
      dconf-settings.enable = !system.profile.isWSL;
      theming.enable = !system.profile.isWSL;
    };
  };

  user.gaming = {
    mangohud.enable = system.profile.isHomePC || system.profile.isSurface;
    lutris.enable = system.profile.isHomePC;
    protonge.enable = system.profile.isHomePC;
    r2modman.enable = system.profile.isHomePC;
    retroarch.enable = system.profile.isHomePC;
    prism-launcher.enable = system.profile.isHomePC || system.profile.isSurface;
  };         
}
