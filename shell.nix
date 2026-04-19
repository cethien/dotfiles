{
  pkgs ? import <nixpkgs> {},
  doot,
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixpkgs-fmt
    sops
    age
    ssh-to-age

    python3
    yq-go
    argc

    doot
    act
  ];

  shellHook =
    #bash
    ''
      STATE_FILE="$PWD/.devshell/.initialized"
      FIRST_RUN=false
      if [ ! -f "$STATE_FILE" ]; then
        FIRST_RUN=true
        mkdir -p "$PWD/.devshell"
        touch "$STATE_FILE"
      fi

      DOOT_CMD="doot"
      if [ ! -d "$PWD/.direnv" ] && [ -z "$DIRENV_DIR" ]; then
        ln -sf ${doot}/bin/doot ./doot
        DOOT_CMD="./doot"
      fi

      GREEN="\033[1;32m"
      YELLOW="\033[1;33m"
      RESET="\033[0m"

      if [ "$FIRST_RUN" = true ]; then
        echo -e "$GREEN🚀 '$DOOT_CMD' command is ready. Run '$DOOT_CMD' for usage.$RESET"
        if [ "$FIRST_RUN" = true ] && [ "$DOOT_CMD" = "./doot" ]; then
          echo -e "$YELLOW💡 Hint: For best experience, use nix-direnv → https://github.com/nix-community/nix-direnv$RESET"
        fi
      fi
    '';
}
