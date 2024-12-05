{ lib, config, system, ... }:

{
  options.user.apps.enable = lib.mkEnableOption "Enable user applications";

  imports = [
    ./audio.nix

    ./firefox.nix
    ./vscode.nix
    ./media-editing.nix
    
    ./discord.nix
    ./spotify.nix
    
    ./drawio.nix
    ./rnote.nix
    
    ./obs-studio.nix
    
  ];

  config = lib.mkIf config.user.apps.enable {
    user.apps.audio.enable = true;

    user.apps.firefox.enable = true;
    user.apps.vscode.enable = true;
    user.apps.media-editing.enable = true;
    
    user.apps.discord.enable = !system.profile.isSurface;
    user.apps.spotify.enable = !system.profile.isSurface;
    
    user.apps.drawio.enable = !system.profile.isSurface;
    user.apps.rnote.enable = system.profile.isSurface;
    
    user.apps.obs-studio.enable = !system.profile.isSurface;
  };
}