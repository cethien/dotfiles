{ lib, config, ... }:

{
  options.deeznuts.cli.shell.hushlogin.enable = lib.mkEnableOption "Enable hushlogin file";

  config = lib.mkIf config.deeznuts.cli.shell.hushlogin.enable {
    home.file."${config.deeznuts.home.homeDirectory}/.hushlogin".text =
      "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
  };
}
