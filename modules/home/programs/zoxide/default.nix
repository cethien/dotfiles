{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.zoxide;
in
{
  options.deeznuts.programs.zoxide = {
    enable = mkEnableOption "Enable zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = false;
      options = [ "--cmd cd" ];
    };

    programs.bash.initExtra =
      lib.mkOrder 2000 # sh
        ''
          eval "$(${lib.getExe pkgs.zoxide} init bash --cmd cd)"
        '';
  };
}
