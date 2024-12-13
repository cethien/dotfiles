{ ... }:

{
  programs.fd.enable = true;

  home.shellAliases = {
    find = "fd";
    ff = "fd --type f";
    ffd = "fd --type d";
  };
}