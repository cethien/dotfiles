{ pkgs, ... }:
with pkgs;
{
  language-server = {
    ansible-language-server = {
      command = "${ansible-language-server}/bin/ansible-language-server";
      args = [ "--stdio" ];
    };
  };

  language = [
    {
      name = "ansible";
      scope = "source.yaml.ansible";
      injection-regex = "ansible";
      file-types = [ "yaml.ansible" ];
      language-servers = [ "ansible-language-server" ];
      comment-token = "#";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
  ];
}
