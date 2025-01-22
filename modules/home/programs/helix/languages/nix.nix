{ pkgs, ... }:
with pkgs;
{
  language-server = {
    nil.command = "${nil}/bin/nil";
  };

  language = [
    {
      name = "nix";
      language-servers = [ "nil" ];
      formatter = {
        command = "${alejandra}/bin/alejandra";
        args = [ "--quiet" ];
      };
      auto-format = true;
    }
  ];
}
