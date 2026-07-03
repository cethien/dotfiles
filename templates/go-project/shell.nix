{pkgs ? import <nixpkgs> {}}: let
  goEnv = with pkgs; [
    go
    gopls
    golangci-lint
    go-tools
    gofumpt
    impl
    wgo
    delve
  ];
in
  pkgs.mkShell {
    packages = with pkgs; [
      git
      lefthook
      commitlint-rs

      goEnv
      just
      just-lsp
    ];

    shellHook =
      #sh
      ''
        [ -d .git ] && [ -f .lefthook.yml ] && lefthook install
        [ -f go.mod  ] && go mod tidy
      '';
  }
