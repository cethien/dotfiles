{
  "*".identityFile = "~/.ssh/id_ed25519";
  "*".user = "bso";

  "monitoring-01".hostname = "10.0.40.11";
  "monitoring-02".hostname = "10.0.40.12";

  "bitbucket-runner".hostname = "10.180.80.220";
  "magento-content".hostname = "10.102.99.215";

  "wp-test".user = "sysadmin";
  "wp-test".hostname = "10.180.80.92";

  "anna-auftrag".user = "sysadmin";
  "anna-auftrag".hostname = "10.102.99.85";

  "sdg".hostname = "10.102.99.92";
  "sdg".user = "sysadmin";
  "toja-prod".hostname = "10.102.99.205";
  "toja-prod".user = "sysadmin";
  "sherlock-prod".hostname = "10.102.99.90";
  "sherlock-prod".user = "sysadmin";
  "bnl".hostname = "10.102.99.93";
  "bnl".user = "root";

  "weclapp-prod".hostname = "10.102.99.97";
  "weclapp-prod".user = "root";
  "weclapp-test".hostname = "10.102.99.96";
  "weclapp-test".user = "root";

  "docker-prod-1".hostname = "10.102.99.95";

  "prmx-virt-cl-1-node-a".hostname = "10.180.80.252";
  "prmx-virt-cl-1-node-b".hostname = "10.180.80.250";

  "maxcluster-prod" = {
    user = "web-user";
    hostname = "109.71.72.118";
  };
  "maxcluster-staging" = {
    user = "web-user";
    hostname = "109.71.72.244";
  };
}
