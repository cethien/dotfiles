{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.shell.bash = {
    enable = lib.mkEnableOption "Enable bash";
    loadNixProfile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to add nix profile loading to bash init. for when on non-NixOS distro
      '';
    };
  };
  config = lib.mkIf config.deeznuts.cli.shell.bash.enable {
    programs.bash = {
      enable = true;

      bashrcExtra = ''
        ${if config.deeznuts.cli.shell.bash.loadNixProfile then ''
          if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
          fi
        '' else ""}
      '';

      initExtra = ''
        export PATH=$GOBIN:$PATH
        source $(blesh-share)/ble.sh
      '';
    };

    home.packages = with pkgs; [ blesh ];
  };
}
