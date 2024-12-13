{ pkgs, ... }:

{
  home.packages = with pkgs; [
    duf
  ];

  home.shellAliases = {
    df = "duf";
  };
}