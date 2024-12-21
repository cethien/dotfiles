{ lib, config, ... }:

{
  options.cli.shell.hushlogin.enable = lib.mkEnableOption "Enable hushlogin file";

  config = lib.mkIf config.cli.shell.hushlogin.enable {
    home.file."${config.home.homeDirectory}/.hushlogin".text =
      "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  };
}
