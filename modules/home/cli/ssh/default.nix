{ lib, config, ... }:

{
  options.cli.ssh.enable = lib.mkEnableOption "Enable ssh";

  config = lib.mkIf config.cli.ssh.enable {
    programs.ssh = {
      enable = true;

      compression = true;
      forwardAgent = true;
      hashKnownHosts = true;
    };
  };
}
