{
  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      goEnv = with pkgs; [
        go
        gopls
        golangci-lint
        go-tools
        impl
        wgo
        delve
      ];
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          lefthook
          commitlint-rs

          just
          goEnv
        ];

        shellHook = ''
          if [ ! -d .git ]; then
            git init && git add . && echo "chore: init" >.git/COMMIT_EDITMSG

            if [ -f lefthook.yaml ]; then
              lefthook install
            fi
          fi

          if [ -f go.mod ]; then
            go mod tidy
          fi
        '';
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
}
