{ lib, config, system, ... }:

{
  options.user.apps.enable = lib.mkEnableOption "Enable user applications";

  imports = [
    ./audio.nix
    ./bitwarden-desktop.nix
    ./discord.nix
    ./drawio.nix
    ./firefox.nix
    ./media-editing.nix
    ./obs-studio.nix
    ./rnote.nix
    ./spotify.nix
    ./vscode.nix
  ];

  config = lib.mkIf config.user.apps.enable {
    user.apps.audio.enable = true;
    user.apps.bitwarden-desktop.enable = !system.profile.isSurface;
    user.apps.discord.enable = !system.profile.isSurface;
    user.apps.drawio.enable = !system.profile.isSurface;
    user.apps.firefox.enable = true;
    user.apps.media-editing.enable = true;
    user.apps.obs-studio.enable = !system.profile.isSurface;
    user.apps.rnote.enable = system.profile.isSurface;
    user.apps.spotify.enable = !system.profile.isSurface;
    user.apps.vscode.enable = true;
  };
}