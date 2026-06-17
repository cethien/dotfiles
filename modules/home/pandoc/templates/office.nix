{pkgs, ...}: let
  template = {
    filter = [
      "${pkgs.mermaid-filter}/bin/mermaid-filter"
      "${pkgs.pandoc-imagine}/bin/pandoc-imagine"
    ];
  };
in
  builtins.toJSON template
