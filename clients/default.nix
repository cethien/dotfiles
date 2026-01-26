let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
  clients =
    builtins.mapAttrs (name: c: {
      hostname = name;
      diskId = c.disk_id;
    })
    toml.clients;
in
  clients
