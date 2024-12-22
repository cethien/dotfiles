{ lib, config, meta, ... }:

{
  options.cli.shell.aliases.enable = lib.mkEnableOption "Enable shell aliases";

  config = lib.mkIf config.cli.shell.aliases.enable {
    home.shellAliases = {
      rebuild-nixos = lib.mkIf meta.isNixOS
        "sudo nixos-rebuild switch --flake ~/.files#${meta.nixos-config}";
      rebuild =
        "home-manager switch --flake ~/.files#${meta.home-manager-config} -b hm-backup-$(date +%Y%m%d_%H%M%S)";

      update = ''
        ${if meta.isWSL then ''
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
        ${if meta.isWSL then ''
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
