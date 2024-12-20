{ config, ... }:

{
  home.file."${config.home.homeDirectory}/.user-scripts".source = ./assets;

  home.shellAliases = {
    init = "source ${config.home.homeDirectory}/.user-scripts/init.sh";
  };
}
