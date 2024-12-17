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

  hardware.bluetooth.enable = !system.profile.isWSL;

  audio.pipewire.enable = !system.profile.isWSL;

  desktop = {
    fonts.enable = !system.profile.isWSL;
    theming.enable = !system.profile.isWSL;

    environment.plasma.enable = true;
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
    vms.enable = system.profile.isHomePC;
    vms.users = [ user.username ];

    docker.enable = !system.profile.isWSL;
    docker.users = [ user.username ];
  };
}
