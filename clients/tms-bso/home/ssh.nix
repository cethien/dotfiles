{
  "Host weclapp-new-test".HostName = "10.0.30.60";
  "Host weclapp-new".HostName = "10.0.30.21";
  "Host magento".HostName = "10.0.30.40";
  "Host services-prod".HostName = "10.0.30.20";
  "Host services-admin".HostName = "10.0.30.10";
  "Host dns-01".HostName = "10.0.30.5";
  "Host dns-02".HostName = "10.0.30.6";

  "Host wp-test" = {
    HostName = "10.180.80.92";
    User = "sysadmin";
  };
  "Host toja-v2" = {
    HostName = "10.102.99.210";
    User = "root";
  };
  "Host anna-auftrag" = {
    HostName = "10.102.99.85";
    User = "sysadmin";
  };
  "Host sdg" = {
    HostName = "10.102.99.92";
    User = "sysadmin";
  };
  "Host toja-prod" = {
    HostName = "10.102.99.205";
    User = "sysadmin";
  };
  "Host sherlock-prod" = {
    HostName = "10.102.99.90";
    User = "sysadmin";
  };

  "Host bnl".HostName = "10.102.99.93";
  "Host weclapp-test".HostName = "10.0.30.97";
  "Host weclapp-prod".HostName = "10.102.99.97";
  "Host kanboard".HostName = "10.102.99.95";

  # --- INFRA
  "Host pi".HostName = "10.0.10.20";
  "Host pve-node-a" = {
    HostName = "10.180.80.252";
    User = "root";
  };
  "Host pve-node-b" = {
    HostName = "10.180.80.250";
    User = "root";
  };
  "Host pve-node-c" = {
    HostName = "10.0.10.7";
    User = "root";
  };

  # --- EXTERNAL
  "Host magento-staging-hetzner".HostName = "65.108.1.248";
  "Host magento-prod" = {
    HostName = "109.71.72.118";
    User = "web-user";
  };
  "Host magento-staging" = {
    HostName = "109.71.72.244";
    User = "web-user";
  };
  "Host kasserver-cdn" = {
    HostName = "w01516e3.kasserver.com";
    User = "ssh-w01516e3";
  };
}
