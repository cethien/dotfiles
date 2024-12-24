{ lib, config, ... }:

{
  options.deeznuts.cli.ssh.enable = lib.mkEnableOption "Enable ssh";

  config = lib.mkIf config.deeznuts.cli.ssh.enable {
    programs.ssh = {
      enable = true;

      compression = true;
      forwardAgent = true;
      hashKnownHosts = true;
    };
  };
}
