{ user, ... }:

{
  users.users."${user.username}" = {
    isNormalUser = true;
    description = "${user.name}";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}