let
  inventory = builtins.fromTOML (builtins.readFile ./inventory.toml);
  inherit (inventory.hosts) defaults;
  mergeHost = host: defaults // host;
  mkHost = name: merged: {
    hostName = name;
    address = merged.address;
    defaultGateway = merged.default_gateway or defaults.default_gateway;
    nameservers = merged.nameservers or defaults.nameservers;
    diskId =
      if merged ? "disk_id"
      then merged.disk_id
      else builtins.warn "Host ${name} is missing 'disk_id' in inventory.toml" null;
  };

  hostNames = builtins.filter (n: n != "defaults") (builtins.attrNames inventory.hosts);
  hosts = map (name: let
    raw = inventory.hosts.${name};
    merged = mergeHost raw;
  in
    if merged.os or defaults.os == "nixos"
    then {
      inherit name;
      value = mkHost name merged;
    }
    else builtins.warn "Skipping ${name}: os != nixos" null)
  hostNames;
in
  builtins.listToAttrs (builtins.filter (x: x != null) hosts)
