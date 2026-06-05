{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;

  deeznuts = {
    mkMimeApps = categories: let
      getDesktopFile = val:
        if lib.hasSuffix ".desktop" val
        then val
        else "${val}.desktop";

      mkHandlers = {
        types,
        desktop,
      }:
        builtins.listToAttrs (map (t: {
            name = t;
            value = [(getDesktopFile desktop)];
          })
          types);
    in
      builtins.foldl' (
        acc: cat:
          acc // mkHandlers cat
      ) {} (builtins.attrValues categories);
  };
in {
  imports = [
    ./argc.nix
  ];

  options.deeznuts = {
    defaultBrowser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "default browser desktop file name";
    };
  };

  config.lib = {inherit deeznuts;};
}
