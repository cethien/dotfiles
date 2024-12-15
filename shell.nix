{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    just
    nil
    nixpkgs-fmt
  ];
}