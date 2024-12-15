{ system, user, ... }:

{
  imports = [
    ./audio
    ./desktop
    ./peripherals
    ./gaming

    ./users.nix
    ./ssh.nix

    ./virtualizing

  ];

  audio = {
    pipewire.enable = true;
    noisetorch.enable = true;
  };

  desktop = {
    fonts.enable = !system.profile.isWSL;
    theming.enable = !system.profile.isWSL;

    gnome.enable = system.profile.isHomePC;
    plasma.enable = false;
  };

  peripherals = {
    print.enable = true;

    logitech.enable = system.profile.isHomePC;
    xbox-controller.enable = system.profile.isHomePC;
    streamdeck.enable = system.profile.isHomePC;
  };

  gaming = {
    opengl.enable = system.profile.isHomePC;
    nvidia.enable = system.profile.isHomePC;
    steam.enable = system.profile.isHomePC;
  };

  virtualizing = {
    gnome-boxes.enable = system.profile.isHomePC;
    docker.enable = !system.profile.isWSL;
    docker.users = [ user.username ];
  };
}
