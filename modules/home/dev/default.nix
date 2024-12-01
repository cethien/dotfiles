{ pkgs,... }:

{
  imports = [
    ./go.nix
    ./bun.nix
    ./ansible.nix
  ];

  home.packages = with pkgs; [
    nil
    nixpkgs-fmt

    quicktype

    act
  ];
}