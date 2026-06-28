{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    git
    lefthook
    commitlint-rs
  ];

  shellHook =
    # bash
    ''
      if [ ! -d .git ]; then
        git init && git add . && echo "chore: init" >.git/COMMIT_EDITMSG

        if [ -f lefthook.yml ]; then
          lefthook install
        fi
      fi
    '';
}
