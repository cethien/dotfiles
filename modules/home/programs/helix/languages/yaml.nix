{ pkgs, ... }:
with pkgs;
{
  language-server = {
    yaml-language-server = {
      command = "${yaml-language-server}/bin/yaml-language-server";
      args = [ "--stdio" ];
    };
  };

  language = [
    {
      name = "yaml";
      scope = "source.yaml";
      injection-regex = "yaml";
      file-types = [ "yaml" "yml" ];
      language-servers = [ "yaml-language-server" ];
      comment-token = "#";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
  ];
}
