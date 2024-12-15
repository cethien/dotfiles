{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    just
    nil
    nixpkgs-fmt
  ];

  shellHook = ''
    if [ ! -f .envrc ]; then
      echo "use flake" > .envrc && direnv allow
    fi
  '';
}