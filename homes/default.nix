let
  toml = builtins.fromTOML (builtins.readFile ../inventory.toml);
  homes = builtins.listToAttrs (map (
    hostname: let
      h = toml.homes.${hostname};
    in {
      name = "${h.user}@${hostname}";
      value = {
        inherit hostname;
        username = h.user;
      };
    }
  ) (builtins.attrNames toml.homes));
in
  homes
