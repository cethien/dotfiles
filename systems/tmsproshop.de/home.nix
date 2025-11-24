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
    firefox.enable = true;
    thunderbird.enable = true;
    thunderbird.profiles."b.sotnikow@tmspro.shop".isDefault = true;

    bash.bashrcExtra = mkBefore ''
      if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';

    ssh.matchBlocksExtra = {
      "*".identityFile = "~/.ssh/id_ed25519";
      "*".user = "bso";

      "srv-bitbucket-runner".hostname = "10.180.80.220";
      "srv-magento-content".hostname = "10.102.99.215";

      "lxc-wp-test-1" = {
        user = "sysadmin";
        hostname = "10.180.80.92";
      };
      "lxc-anna-auftrag" = {
        user = "sysadmin";
        hostname = "10.102.99.85";
      };

      "lxc-sdg" = {
        user = "sysadmin";
        hostname = "10.102.99.92";
      };
      "lxc-phone-search" = {
        user = "sysadmin";
        hostname = "10.102.99.91";
      };
      "lxc-toja-prod" = {
        user = "sysadmin";
        hostname = "10.102.99.205";
      };
      "lxc-sherlock-prod" = {
        user = "sysadmin";
        hostname = "10.102.99.90";
      };
      "srv-bnl" = {
        user = "root";
        hostname = "10.102.99.93";
      };
      "srv-weclapp-prod" = {
        user = "root";
        hostname = "10.180.80.97";
      };
      "srv-weclapp-test".hostname = "10.180.80.94";
      "srv-docker-prod-1".hostname = "10.180.80.93";
      "srv-admin-docker-cluster-node-01".hostname = "10.180.80.201";
      "pve-01".hostname = "10.180.80.252";
      "pve-02".hostname = "10.180.80.250";

      "maxcluster--srv-prod" = {
        user = "web-user";
        hostname = "109.71.72.118";
      };
      "maxcluster--srv-staging" = {
        user = "web-user";
        hostname = "109.71.72.244";
      };
    };
  };
}
