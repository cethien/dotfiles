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

      "pve-01".hostname = "10.180.80.250";
      "pve-02".hostname = "10.180.80.252";
      "srv-admin-docker-cluster-node-01".hostname = "10.180.80.101";

      "srv-weclapp-prod".hostname = "10.180.80.97";
      "srv-weclapp-test".hostname = "10.180.80.94";
      "srv-docker-prod-1".hostname = "10.180.80.93";

      "srv-magento-content".hostname = "10.102.99.215";
      "lxc-magento-runner".hostname = "10.180.80.202";
      "lxc-magento-runner".user = "root";
    };
  };
}
