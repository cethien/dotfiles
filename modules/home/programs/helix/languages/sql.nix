{ pkgs, ... }:
with pkgs;
{
  language-server = {
    sqls.command = "${sqls}/bin/sqls";
  };

  language = [
    {
      name = "sql";
      scope = "source.sql";
      injection-regex = "sql";
      file-types = [ "sql" ];
      language-servers = [ "sqls" ];
      comment-token = "--";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
  ];
}
