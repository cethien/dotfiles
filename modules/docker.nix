{ pkgs, user, ... }:

{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ user.username ];

  environment.systemPackages = with pkgs.gnomeExtensions; [
    docker
  ];
}