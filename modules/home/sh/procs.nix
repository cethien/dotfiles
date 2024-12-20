{ pkgs, ... }:

{
  home.packages = with pkgs; [
    procs
  ];

  home.shellAliases = {
    ps = "procs";
  };
}
