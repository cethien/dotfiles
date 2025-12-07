{lib, ...}: let
  inventory = builtins.fromTOML (builtins.readFile ./deploy.toml);
  inherit (inventory.hosts) defaults;
  mergeHost = host: defaults // host;
  mkHost = name: merged: {
    hostName = name;
    address = merged.address;
    defaultGateway = merged.default_gateway or defaults.default_gateway;
    nameservers = merged.nameservers or defaults.nameservers;
  };

  hostNames = lib.filter (n: n != "defaults") (builtins.attrNames inventory.hosts);
  hosts = map (name: let
    raw = inventory.hosts.${name};
    merged = mergeHost raw;
  in
    if merged.os or defaults.os == "nixos"
    then {
      inherit name;
      value = mkHost name merged;
    }
    else lib.warn "Skipping ${name}: os != nixos" null)
  hostNames;
in
  lib.listToAttrs (lib.filter (x: x != null) hosts)
