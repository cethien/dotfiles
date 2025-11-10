{
  stateVersion,
  lib,
  ...
}: let
  inherit (lib) mkBefore;
  username = "bsotnikow";
in {
  imports = [
    ../../modules/home
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = stateVersion;

  programs = {
    bash.bashrcExtra = mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';

    ssh.matchBlocksExtra = {
      "pve-01" = {
        host = "pve-01";
        hostname = "10.180.80.250";
      };
      "pve-02" = {
        host = "pve-02";
        hostname = "10.180.80.252";
      };

      weclapp = {
        host = "weclapp-prod";
        hostname = "10.180.80.97";
      };

      weclapp-test = {
        host = "weclapp-test";
        hostname = "10.180.80.94";
      };

      "docker-node-01" = {
        host = "srv-admin-docker-cluster-node-01";
        hostname = "10.180.80.101";
      };

      "docker-prod" = {
        host = "docker-prod-1";
        hostname = "10.180.80.93";
      };
    };
  };
}
