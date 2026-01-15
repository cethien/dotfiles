{
  "*".identityFile = "~/.ssh/id_ed25519";
  "*".user = "bso";

  "bitbucket-runner".hostname = "10.0.30.20";
  "magento-content".hostname = "10.102.99.201";
  "magento-qa".hostname = "10.102.99.203";
  "magento-qa".user = "root";

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
  "weclapp-test".hostname = "10.102.99.96";
  "weclapp-update-test".hostname = "10.0.30.31";

  "docker-prod-1".hostname = "10.102.99.95";

  "monitoring-01".hostname = "10.0.40.11";
  "monitoring-02".hostname = "10.0.40.12";

  # --- INFRA

  "deez-nut".hostname = "10.0.10.20";
  "prmx-virt-cl-1-node-a".hostname = "10.180.80.252";
  "prmx-virt-cl-1-node-b".hostname = "10.180.80.250";

  # --- EXTERNAL

  "maxcluster-prod" = {
    user = "web-user";
    hostname = "109.71.72.118";
  };
  "maxcluster-staging" = {
    user = "web-user";
    hostname = "109.71.72.244";
  };

  "allinkl-ftp".hostname = "w01516e3.kasserver.com";
  "allinkl-ftp".user = "ssh-w01516e3";
}
