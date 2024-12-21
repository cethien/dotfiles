{ lib, config, ... }:

{
  options.cli.shell.oh-my-posh.enable = lib.mkEnableOption "Enable oh-my-posh";

  config = lib.mkIf config.cli.shell.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      useTheme = "pure";
    };
  };
}
