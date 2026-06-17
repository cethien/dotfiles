{pkgs, ...}: let
  template = {
    citeproc = true;
    pdf-engine = "${pkgs.python313Packages.weasyprint}/bin/weasyprint";
    filters = [
      {
        type = "json";
        path = "${pkgs.pandoc-acro}/bin/pandoc-acro";
      }
      {
        type = "json";
        path = "${pkgs.pandoc-fignos}/bin/pandoc-fignos";
      }
      {
        type = "json";
        path = "${pkgs.pandoc-eqnos}/bin/pandoc-eqnos";
      }
      {
        type = "json";
        path = "${pkgs.pandoc-tablenos}/bin/pandoc-tablenos";
      }
      {
        type = "json";
        path = "${pkgs.pandoc-secnos}/bin/pandoc-secnos";
      }
    ];
  };
in
  builtins.toJSON template
