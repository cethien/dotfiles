{ pkgs, ... }:
with pkgs;
{
  language-server = {
    bash-language-server = {
      command = "${bash-language-server}/bin/bash-language-server";
      args = [ "start" ];
    };
  };

  language = [
    {
      name = "bash";
      auto-format = true;
    }
  ];
}
