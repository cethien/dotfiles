{ pkgs, ... }:
with pkgs;
{
  language-server = with pkgs; {
    typescript-language-server = with nodePackages; {
      command = "${typescript-language-server}/bin/typescript-language-server";
      args = [ "--stdio" ];
      config = {
        hostInfo = "helix";
        typescript.inlayHints = {
          includeInlayEnumMemberValueHints = true;
          includeInlayFunctionLikeReturnTypeHints = true;
          includeInlayFunctionParameterTypeHints = true;
          includeInlayParameterNameHints = "all";
          includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          includeInlayPropertyDeclarationTypeHints = true;
          includeInlayVariableTypeHints = true;
        };
        javascript.inlayHints = {
          includeInlayEnumMemberValueHints = true;
          includeInlayFunctionLikeReturnTypeHints = true;
          includeInlayFunctionParameterTypeHints = true;
          includeInlayParameterNameHints = "all";
          includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          includeInlayPropertyDeclarationTypeHints = true;
          includeInlayVariableTypeHints = true;
        };
      };
    };

    vscode-css-language-server = with nodePackages; {
      command = "${vscode-langservers-extracted}/bin/vscode-css-language-server";
      args = [ "--stdio" ];
      config = {
        provideFormatter = true;
        css = {
          validate = {
            enable = true;
          };
        };
      };
    };

    vscode-html-language-server = with nodePackages; {
      command = "${vscode-langservers-extracted}/bin/vscode-html-language-server";
      args = [ "--stdio" ];
      config = {
        provideFormatter = true;
      };
    };

    vscode-json-language-server = with nodePackages; {
      command = "${vscode-langservers-extracted}/bin/vscode-json-language-server";
      args = [ "--stdio" ];
      config = {
        provideFormatter = true;
        json = {
          validate = {
            enable = true;
          };
        };
      };
    };
  };

  language = [
    {
      name = "css";
      scope = "source.css";
      injection-regex = "css";
      file-types = [ "css" "scss" ];
      block-comment-tokens = {
        start = "/*";
        end = "*/";
      };
      language-servers = [ "vscode-css-language-server" ];
      auto-format = true;
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
    {
      name = "html";
      scope = "text.html.basic";
      injection-regex = "html";
      file-types = [
        "asp"
        "aspx"
        "htm"
        "html"
        "jshtm"
        "jsp"
        "rhtml"
        "shtml"
        "volt"
        "xht"
        "xhtml"
      ];
      block-comment-tokens = {
        start = "<!--";
        end = "-->";
      };
      language-servers = [ "vscode-html-language-server" ];
      auto-format = true;
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
    {
      name = "javascript";
      scope = "source.js";
      injection-regex = "(js|javascript)";
      language-id = "javascript";
      file-types = [
        "js"
        "mjs"
        "cjs"
        "rules"
        "es6"
        "pac"
        { glob = ".node_repl_history"; }
        { glob = "jakefile"; }
      ];
      shebangs = [ "node" ];
      comment-token = "//";
      block-comment-tokens = {
        start = "/*";
        end = "*/";
      };
      language-servers = [ "typescript-language-server" ];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      debugger = {
        name = "node-debug2";
        transport = "stdio";
        quirks = { absolute-paths = true; };
        templates = [
          {
            name = "source";
            request = "launch";
            completion = [
              {
                name = "main";
                completion = "filename";
                default = "index.js";
              }
            ];
            args = { program = "{0}"; };
          }
        ];
      };
    }
  ];
}
