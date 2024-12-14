{ system, user, ... }:

{
  imports = [
    ./audio
    ./peripherals
    ./gaming

    ./users
    ./ssh.nix

    ./virtualizing

    ./desktop.nix
  ];

  audio = {
    pipewire.enable = true;
    noisetorch.enable = true;
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
