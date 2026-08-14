{pkgs ? null}: let
  mkHost = attrs:
    {
      RemoteCommand = "command -v tmux >/dev/null 2>&1 && (tmux attach || tmux new-session) || exec $SHELL";
      RequestTTY = "yes";
    }
    // attrs;

  raw = {
    "Host weclapp-test" = mkHost {HostName = "10.0.30.60";};
    "Host weclapp" = mkHost {HostName = "10.0.30.21";};
    "Host magento" = mkHost {HostName = "10.0.30.40";};
    "Host services-prod" = mkHost {HostName = "10.0.30.20";};
    "Host services-admin" = mkHost {HostName = "10.0.30.10";};
    "Host dns-01" = mkHost {HostName = "10.0.30.5";};
    "Host dns-02" = mkHost {HostName = "10.0.30.6";};

    "Host wp-test" = mkHost {
      HostName = "10.180.80.92";
      User = "sysadmin";
    };
    "Host toja" = mkHost {
      HostName = "10.102.99.210";
      User = "root";
    };

    # --- INFRA
    "Host truenas" = mkHost {
      HostName = "10.180.80.87";
      User = "truenas_admin";
    };
    "Host pi" = mkHost {HostName = "10.0.10.20";};
    "Host pve-node-a" = mkHost {
      HostName = "10.0.10.5";
      User = "root";
    };
    "Host pve-node-b" = mkHost {
      HostName = "10.180.80.250";
      User = "root";
    };
    "Host pve-node-c" = mkHost {
      HostName = "10.0.10.7";
      User = "root";
    };

    # --- EXTERNAL
    "Host magento-staging-hetzner" = mkHost {HostName = "65.108.1.248";};
    "Host magento-prod" = mkHost {
      HostName = "109.71.72.118";
      User = "web-user";
    };
    "Host magento-staging" = mkHost {
      HostName = "109.71.72.244";
      User = "web-user";
    };
    "Host kasserver-cdn" = mkHost {
      HostName = "w01516e3.kasserver.com";
      User = "ssh-w01516e3";
    };
  };

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
  inherit raw;
  asIncludePath = toString (pkgs.writeText "tms-ssh-config" (toSshConfigString raw));
}
