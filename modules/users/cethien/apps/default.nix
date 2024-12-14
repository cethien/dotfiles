{ lib, config, system, ... }:

{
  options.user.apps.enable = lib.mkEnableOption "Enable user applications";

  imports = [
    ./audio.nix

    ./flameshot.nix

    ./firefox.nix
    ./spotify.nix
    ./keepassxc.nix
    ./vscode.nix
    ./drawio.nix
    ./rnote.nix
    
    ./discord.nix
    ./ocenaudio.nix
    ./inkscape.nix         
    ./obs-studio.nix    
  ];

  config = lib.mkIf config.user.apps.enable {
    user.apps.audio.enable = true;

    user.apps.flameshot.enable = true;

    user.apps.firefox.enable = true;
    user.apps.spotify.enable = true;
    user.apps.vscode.enable = true;
    user.apps.keepassxc.enable = true;
    user.apps.drawio.enable = true;
    user.apps.rnote.enable = system.profile.isSurface;
    
    user.apps.discord.enable = system.profile.isHomePC;
    user.apps.ocenaudio.enable = system.profile.isHomePC;
    user.apps.inkscape.enable = system.profile.isHomePC;
    user.apps.obs-studio.enable = system.profile.isHomePC;
  };
}