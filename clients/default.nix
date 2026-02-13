let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
  defaults = toml.defaults.clients;
  mergedClients = builtins.mapAttrs (_: client: defaults // client) toml.clients;

  clients =
    builtins.mapAttrs (name: c: {
      hostName = name;
      user = c.user;
      diskId = c.disk_id;
    })
    mergedClients;
in
  clients
