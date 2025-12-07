{lib, ...}: let
  clients = [
    "hp-430-g7"
    # "tower-of-power"
  ];
in
  lib.listToAttrs (map (c: {
      name = c;
      value = {hostName = c;};
    })
    clients)
