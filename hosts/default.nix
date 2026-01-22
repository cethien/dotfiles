let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
  defaults = toml.defaults.hosts;
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

  hosts = map (name: let
    raw = toml.hosts.${name};
    merged = mergeHost raw;
  in
    if merged.os or defaults.os == "nixos"
    then {
      inherit name;
      value = mkHost name merged;
    }
    else builtins.warn "Skipping ${name}: os != nixos" null)
  (builtins.attrNames toml.hosts);
in
  builtins.listToAttrs (builtins.filter (x: !isNull x) hosts)
