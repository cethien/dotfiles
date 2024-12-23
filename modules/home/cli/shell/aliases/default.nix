{ lib, config, ... }:

{
  options.cli.shell.aliases = {
    enable = lib.mkEnableOption "Enable shell aliases";

    nixosRebuild = {
      enable = lib.mkEnableOption "Enable nixos rebuild alias";
      configName = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "NixOS config name for rebuild alias";
      };
    };

    apt.enable = lib.mkEnableOption "Enable apt specific aliases options";

    homeManagerConfigName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Home manager config name for rebuild alias";
    };
  };

  config = lib.mkIf config.cli.shell.aliases.enable {
    home.shellAliases = {
      rebuild-nixos = lib.mkIf config.cli.shell.aliases.nixosRebuild.enable
        "sudo nixos-rebuild switch --flake github:cethien/.files#${config.cli.shell.aliases.nixosRebuild.configName}";
      rebuild =
        "home-manager switch --flake github:cethien/.files#${config.cli.shell.aliases.homeManagerConfigName}";

      update = ''
        ${if config.cli.shell.aliases.apt.enable then ''
        PM=apt
        # use nala if available
        if ! command -v nala &> /dev/null; then
          PM=nala
        fi

        sudo $PM update && sudo $PM upgrade -y
        '' else ""}
        nix flake update --flake github:cethien/.files
      '';

      clean = ''
        ${if config.cli.shell.aliases.apt.enable then ''
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
