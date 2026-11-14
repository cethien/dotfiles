{
  pkgs,
  pkgs-unstable,
  doot,
}:
pkgs.mkShell {
  packages = with pkgs-unstable; [
    # CLI Helper, Security & Scripting Tools (Rolling)
    sops
    age
    ssh-to-age

    argc
    gum
    yq-go

    nix-output-monitor
    nurl
    nvd

    act

    doot
  ];

  shellHook = let
    yaziStubs = pkgs.runCommand "yazi-types-stubs" {} ''
      mkdir -p $out/types.yazi
      cp ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yazi-rs/plugins/1ef5fe02a6122f8f3bb47a41056aab3f4b8598bf/types.yazi/main.lua";
        hash = "sha256-oIDDSsrvKH206SD3rlzW0DiaJkmLLswgBcg3esaTGMs=";
      }} $out/types.yazi/main.lua
    '';

    luarcContent = {
      diagnostics = {
        globals = ["vim" "yazi" "cx" "ya" "hl"];
      };
      workspace = {
        library = [
          "${pkgs-unstable.hyprland}/share/hypr/stubs"
          "${yaziStubs}/types.yazi"
          "${pkgs-unstable.neovim-unwrapped}/share/nvim/runtime/lua"
        ];
        checkThirdParty = false;
      };
    };

    luarcFile = pkgs.writeText "luarc.json" (builtins.toJSON luarcContent);
  in
    # bash
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
