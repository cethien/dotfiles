{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    nixpkgs-fmt
    sops
    tomlq
    just
  ];
}
