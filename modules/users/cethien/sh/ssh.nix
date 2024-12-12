{ ... }:

{
  programs.ssh = {
    enable = true;

    compression = true;
    forwardAgent = true;
    hashKnownHosts = true;
  };
}