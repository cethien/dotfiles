{ user, ... }:

{
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ user.username ];
}