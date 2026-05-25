{
  programs.ssh = {
    matchBlocksExtra = {
      "*".identityFile = "~/.ssh/id_ed25519";

      "weclapp-new-test".hostname = "10.0.30.60";
      "weclapp-new".hostname = "10.0.30.21";
      "magento".hostname = "10.0.30.40";
      "services-prod".hostname = "10.0.30.20";
      "services-admin".hostname = "10.0.30.10";
      "dns-01".hostname = "10.0.30.5";
      "dns-02".hostname = "10.0.30.6";

      "wp-test".hostname = "10.180.80.92";
      "wp-test".user = "sysadmin";

      "toja-v2".hostname = "10.102.99.210";
      "toja-v2".user = "root";

      "anna-auftrag".hostname = "10.102.99.85";
      "anna-auftrag".user = "sysadmin";

      "sdg".hostname = "10.102.99.92";
      "sdg".user = "sysadmin";

      "toja-prod".hostname = "10.102.99.205";
      "toja-prod".user = "sysadmin";

      "sherlock-prod".hostname = "10.102.99.90";
      "sherlock-prod".user = "sysadmin";

      "bnl".hostname = "10.102.99.93";

      "weclapp-test".hostname = "10.0.30.97";
      "weclapp-prod".hostname = "10.102.99.97";
      "kanboard".hostname = "10.102.99.95";

      # --- INFRA

      "pi".hostname = "10.0.10.20";
      "pve-node-a".hostname = "10.180.80.252";
      "pve-node-a".user = "root";

      "pve-node-b".hostname = "10.180.80.250";
      "pve-node-b".user = "root";

      "pve-node-c".hostname = "10.0.10.7";
      "pve-node-c".user = "root";
      # --- EXTERNAL

      "magento-staging-hetzner".hostname = "65.108.1.248";

      "magento-prod".hostname = "109.71.72.118";
      "magento-prod".user = "web-user";

      "magento-staging".hostname = "109.71.72.244";
      "magento-staging".user = "web-user";

      "kasserver-cdn".hostname = "w01516e3.kasserver.com";
      "kasserver-cdn".user = "ssh-w01516e3";
    };
  };
}
