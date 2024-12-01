{ user, ... }:

{
  users.users."${user.username}" = {
    isNormalUser = true;
    description = "${user.name}";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  imports = [
    ./audio.nix
    ./desktop.nix
    ./docker.nix
    ./gaming
    ./peripherals.nix
    ./virtualization.nix
  ];
}