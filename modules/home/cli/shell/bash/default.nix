{ lib, config, pkgs, ... }:

{
  options.cli.shell.bash.enable = lib.mkEnableOption "Enable bash";

  config = lib.mkIf config.cli.shell.bash.enable {
    programs.bash = {
      enable = true;

      initExtra = ''
        export PATH=$GOBIN:$PATH
        source $(blesh-share)/ble.sh
      '';
    };

    home.packages = with pkgs; [ blesh ];
  };
}
