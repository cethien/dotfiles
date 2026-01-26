let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
  homes =
    builtins.mapAttrs (name: h: {
      hostname = name;
      username = h.user;
    })
    toml.homes;
in
  homes
