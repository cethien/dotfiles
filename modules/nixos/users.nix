{ ... }:

{
  users.users."cethien" = {
    isNormalUser = true;
    description = "Boris";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
