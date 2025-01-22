{ pkgs, ... }:
with pkgs;
{
  language-server = {
    gopls = {
      command = "${gopls}/bin/gopls";
      config.hints = {
        assignVariableTypes = true;
        compositeLiteralFields = true;
        compositeLiteralTypes = true;
        constantValues = true;
        functionTypeParameters = true;
        parameterNames = true;
        rangeVariableTypes = true;
      };
    };

    golangci-lint-lsp.command = "${golangci-lint-langserver}/bin/golangci-lint-langserver";
  };

  language = [
    {
      name = "go";
      language-servers = [ "gopls" "golangci-lint-lsp" ];
      formatter.command = "go fmt";
      auto-format = true;
    }
  ];
}
