{pkgs, ...}: let
  template = {
    filters = [
      {
        type = "json";
        path = "${pkgs.pandoc-imagine}/bin/pandoc-imagine";
      }
    ];
  };
in
  builtins.toJSON template
