{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.deeznuts.programs.helix;
  enabled = cfg.enable;
in {
  options.deeznuts.programs.helix = {
    enable = mkEnableOption "Helix editor";
  };

  config = mkIf enabled {
    home.sessionVariables.EDITOR = "hx";

    programs.helix = with pkgs; {
      enable = true;
      defaultEditor = mkDefault true;

      languages = {
        language-server = {
          nil.command = "${nil}/bin/nil";
          bash-language-server = {
            command = "${bash-language-server}/bin/bash-language-server";
            args = ["start"];
          };
          docker-langserver = {
            command = "${dockerfile-language-server-nodejs}/bin/docker-langserver";
            args = ["--stdio"];
          };
          docker-compose-langserver = {
            command = "${docker-compose-language-service}/bin/docker-compose-langserver";
            args = ["--stdio"];
          };
          ansible-language-server = {
            command = "${ansible-language-server}/bin/ansible-language-server";
            args = ["--stdio"];
          };
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
          sqls.command = "${sqls}/bin/sqls";
          typescript-language-server = with nodePackages; {
            command = "${typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
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
            args = ["--stdio"];
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
            args = ["--stdio"];
            config = {
              provideFormatter = true;
            };
          };
          vscode-json-language-server = with nodePackages; {
            command = "${vscode-langservers-extracted}/bin/vscode-json-language-server";
            args = ["--stdio"];
            config = {
              provideFormatter = true;
              json = {
                validate = {
                  enable = true;
                };
              };
            };
          };
          yaml-language-server = {
            command = "${yaml-language-server}/bin/yaml-language-server";
            args = ["--stdio"];
          };
        };

        language = [
          {
            name = "nix";
            language-servers = ["nil"];
            formatter = {
              command = "${alejandra}/bin/alejandra";
              args = ["--quiet"];
            };
            auto-format = true;
          }
          {
            name = "bash";
            auto-format = true;
          }
          {
            name = "go";
            language-servers = ["gopls" "golangci-lint-lsp"];
            formatter.command = "go fmt";
            auto-format = true;
          }
          {
            name = "css";
            scope = "source.css";
            injection-regex = "css";
            file-types = ["css" "scss"];
            block-comment-tokens = {
              start = "/*";
              end = "*/";
            };
            language-servers = ["vscode-css-language-server"];
            auto-format = true;
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
          {
            name = "dockerfile";
            scope = "source.dockerfile";
            injection-regex = "docker|dockerfile";
            roots = ["Dockerfile" "Containerfile"];
            file-types = [
              "Dockerfile"
              {glob = "Dockerfile";}
              {glob = "Dockerfile.*";}
              "dockerfile"
              {glob = "dockerfile";}
              {glob = "dockerfile.*";}
              "Containerfile"
              {glob = "Containerfile";}
              {glob = "Containerfile.*";}
              "containerfile"
              {glob = "containerfile";}
              {glob = "containerfile.*";}
            ];
            comment-token = "#";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            language-servers = ["docker-langserver"];
          }
          {
            name = "docker-compose";
            scope = "source.yaml.docker-compose";
            roots = [
              "docker-compose.yaml"
              "docker-compose.yml"
            ];
            language-servers = [
              "docker-compose-langserver"
              "yaml-language-server"
            ];
            file-types = [
              {glob = "docker-compose.yaml";}
              {glob = "docker-compose.yml";}
            ];
            comment-token = "#";
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
            language-servers = ["vscode-html-language-server"];
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
              {glob = ".node_repl_history";}
              {glob = "jakefile";}
            ];
            shebangs = ["node"];
            comment-token = "//";
            block-comment-tokens = {
              start = "/*";
              end = "*/";
            };
            language-servers = ["typescript-language-server"];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            debugger = {
              name = "node-debug2";
              transport = "stdio";
              quirks = {absolute-paths = true;};
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
                  args = {program = "{0}";};
                }
              ];
            };
          }
        ];
      };

      settings = {
        editor = {
          line-number = "absolute";
          cursorline = true;
          color-modes = true;

          soft-wrap.enable = true;

          auto-save = {
            focus-lost = true;
            after-delay.enable = true;
          };

          indent-guides = {
            character = "┊";
            render = true;
            skip-levels = 1;
          };

          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };

        keys.normal = {
          space.space = "file_picker";
          space.q = ":q";
          esc = ["collapse_selection" "keep_primary_selection"];
          C-s = ":w";
          C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
        };
      };
    };
  };
}
