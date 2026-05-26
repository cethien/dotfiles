{pkgs ? import <nixpkgs> {}}: let
  goEnv = with pkgs; [
    go
    gopls
    golangci-lint
    go-tools
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
    ];

    shellHook = ''
      if [ ! -d .git ]; then
        git init && git add . && echo "chore: init" >.git/COMMIT_EDITMSG

        if [ -f lefthook.yml ]; then
          lefthook install
        fi
      fi

      if [ -f go.mod ]; then
        go mod tidy
      fi
    '';
  }
