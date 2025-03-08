{
  programs.nixvim.plugins.lsp.servers = {
    nil_ls = {
      enable = true;
      settings.formatting.command = [
        "nixpkgs-fmt"
      ];
    };
    bashls.enable = true;

    yamlls.enable = true;
    jsonls.enable = true;

    dockerls.enable = true;

    ansiblels.enable = true;

    sqls.enable = true;

    lua_ls.enable = true;

    html.enable = true;
    cssls.enable = true;

    ts_ls.enable = true;
    eslint.enable = true;

    htmx.enable = true;
    tailwindcss.enable = true;

    svelte.enable = true;

    gopls = {
      enable = true;
      settings = {
        completeUnimported = true;
        usePlaceholders = true;
      };
    };
    golangci_lint_ls.enable = true;
    templ.enable = true;
  };
}
