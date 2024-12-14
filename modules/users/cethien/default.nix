{ system, config, ... }:

{
  imports = [
    ./sh
    ./dev
    ./customization
    ./apps
    ./gaming
  ];

  user.apps.enable = system.profile.isNixos;
  user.dev.enable = true;
  user.gaming.enable = system.profile.isHomePC;

  # hushlogin file
  home.file."${config.home.homeDirectory}/.hushlogin".text = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  home.file."${config.home.homeDirectory}/.user-scripts".source = ./scripts;
}
