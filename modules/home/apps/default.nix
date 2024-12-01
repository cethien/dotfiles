{ pkgs,... }: 

{
  imports = [
    ./firefox.nix
    ./spotify.nix
    ./vscode.nix
    ./obs-studio.nix
  ];

  home.packages = with pkgs; [
    keepassxc

    qpwgraph
    carla

    vesktop
    bitwarden-desktop

    drawio
    ocenaudio

    prismlauncher
  ];

}