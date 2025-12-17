let
  inventory = builtins.fromTOML (builtins.readFile ../inventory.toml);
in
  builtins.mapAttrs (name: c: {
    hostName = name;
    diskId = c.disk_id;
  })
  inventory.clients

