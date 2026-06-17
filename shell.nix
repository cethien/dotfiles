{
  pkgs ? import <nixpkgs> {},
  doot,
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    alejandra
    lua-language-server
    stylua
    bash-language-server
    shfmt

    sops
    age
    ssh-to-age
    yq-go
    argc
    gum
    doot

    act
  ];

  shellHook = let
    yaziStubs = "${pkgs.yazi}/share/yazi/stubs";

    luarcContent = {
      diagnostics = {
        globals = ["vim" "yazi" "cx" "ya" "hyprland"];
      };
      workspace = {
        library = [
          # 1. Hyprland Typen/Stubs aus dem Nix-Store
          "${pkgs.hyprland}/share/hypr/stubs"

          # 2. Yazi Typen/Stubs aus dem Nix-Store
          yaziStubs

          # 3. Native Neovim-Laufzeit-Typen (wird im Editor dynamisch aufgelöst)
          "$VIMRUNTIME/lua"
        ];
        checkThirdParty = false;
      };
    };

    luarcFile = pkgs.writeText "luarc.json" (builtins.toJSON luarcContent);
  in
    #bash
    ''
      STATE_FILE="$PWD/.devshell/.initialized"
      FIRST_RUN=false
      if [ ! -f "$STATE_FILE" ]; then
        FIRST_RUN=true
        mkdir -p "$PWD/.devshell"
        touch "$STATE_FILE"
      fi

      cp -f ${luarcFile} "$PWD/.luarc.json"
      chmod +w "$PWD/.luarc.json"

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
