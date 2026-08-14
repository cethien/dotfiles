{pkgs ? null}: let
  raw = {
    "Host weclapp-test".HostName = "10.0.30.60";
    "Host weclapp".HostName = "10.0.30.21";
    "Host magento".HostName = "10.0.30.40";
    "Host services-prod".HostName = "10.0.30.20";
    "Host services-admin".HostName = "10.0.30.10";
    "Host dns-01".HostName = "10.0.30.5";
    "Host dns-02".HostName = "10.0.30.6";

    "Host wp-test" = {
      HostName = "10.180.80.92";
      User = "sysadmin";
    };
    "Host toja" = {
      HostName = "10.102.99.210";
      User = "root";
    };

    # --- INFRA
    "Host truenas" = {
      HostName = "10.180.80.87";
      User = "truenas_admin";
    };
    "Host pi".HostName = "10.0.10.20";
    "Host pve-node-a" = {
      HostName = "10.0.10.5";
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
  };

  asSettings = defaults:
    builtins.mapAttrs (name: value: defaults // value) raw;

  toSshConfigString = settings: let
    toBlock = key: attrs: let
      header =
        if builtins.substring 0 5 key == "Host " || builtins.substring 0 6 key == "Match "
        then key
        else "Host ${key}";
      lines = map (k: "  ${k} ${toString attrs.${k}}") (builtins.attrNames attrs);
    in
      "${header}\n" + (builtins.concatStringsSep "\n" lines);
  in
    builtins.concatStringsSep "\n\n" (map (key: toBlock key settings.${key}) (builtins.attrNames settings));
in {
  inherit raw asSettings;

  asIncludePath = defaults:
    pkgs.writeText "tms-ssh-config" (toSshConfigString (asSettings defaults));
}
