{ lib, config, ... }:

{
  options.cli.shell.aliases.enable = lib.mkEnableOption "Enable shell aliases";

  config = lib.mkIf config.cli.shell.aliases.enable {
    home.shellAliases = {
      rebuild =
        if config.isWSL then ''
          home-manager switch --flake ~/.files#wsl
        '' else ''
          sudo nixos-rebuild switch --flake ~/.files#tower-of-power
        '';

      update = ''
        ${if config.isWSL then ''
        PM=apt
        # use nala if available
        if ! command -v nala &> /dev/null; then
          PM=nala
        fi

        sudo $PM update && sudo $PM upgrade -y
        '' else ""}
        nix flake update --flake ~/.files
      '';

      clean = ''
        ${if config.isWSL then ''
        PM=apt
        # use nala if available
        if ! command -v nala &> /dev/null; then
          PM=nala
        fi
        sudo $PM autoremove -y
        '' else ""}
        nix-env --delete-generations 3d
        nix-store --gc
      '';

      reload = "source ~/.bashrc && clear";
    };
  };

}
