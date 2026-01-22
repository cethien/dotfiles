let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
in
  builtins.mapAttrs (name: c: {
    hostName = name;
    diskId = c.disk_id;
  })
  toml.clients
