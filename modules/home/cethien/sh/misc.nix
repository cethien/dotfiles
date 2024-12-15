{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    wget
    zip
    unzip
  ];
}
