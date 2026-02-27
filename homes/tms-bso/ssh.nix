{
  programs.ssh = {
    matchBlocksExtra = {
      "*".identityFile = "~/.ssh/id_ed25519";
      "*".user = "bso";

      "dns-01".hostname = "10.0.30.5";
      "dns-02".hostname = "10.0.30.6";

      "rclone".hostname = "10.0.30.21";
      "bitbucket-runner".hostname = "10.0.30.20";
      "magento".hostname = "10.0.30.40";

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
      "bnl".user = "root";

      "weclapp-prod".hostname = "10.102.99.97";
      "weclapp-test".hostname = "10.0.30.97";
      "weclapp-test-update".hostname = "10.0.30.96";

      "docker-prod-1".hostname = "10.102.99.95";

      "svcs-01".hostname = "10.0.30.10";
      "svcs-02".hostname = "10.0.30.11";
      "svcs-03".hostname = "10.0.30.12";
      "mgmt-01".hostname = "10.0.40.10";
      "mgmt-02".hostname = "10.0.40.11";
      "mgmt-03".hostname = "10.0.40.12";

      # --- INFRA

      "deez-nut".hostname = "10.0.10.20";
      "prmx-virt-cl-1-node-a".hostname = "10.180.80.252";
      "prmx-virt-cl-1-node-b".hostname = "10.180.80.250";
      "pve-node-c".hostname = "10.0.10.7";
      # --- EXTERNAL

      "maxcluster-prod".hostname = "109.71.72.118";
      "maxcluster-prod".user = "web-user";

      "maxcluster-staging".hostname = "109.71.72.244";
      "maxcluster-staging".user = "web-user";

      "kasserver-cdn".hostname = "w01516e3.kasserver.com";
      "kasserver-cdn".user = "ssh-w01516e3";
    };
  };
}
