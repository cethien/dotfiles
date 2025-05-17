{
  programs.nixvim.plugins = {
    lsp.enable = true;
    # lspconfig.enable = true;
    lsp-format.enable = true;
  };

  programs.nixvim.plugins.lsp = {
    servers = {
      clangd.enable = true;
      clangd.settings = {
        cmd = [
          "clangd"
          "--background-index"
        ];
        filetypes = [
          "c"
          "cpp"
        ];
        root_markers = [
          "compile_commands.json"
          "compile_flags.txt"
        ];
      };

      phpactor.enable = true;
      phan.enable = true;

      templ.enable = true;
      golangci_lint_ls.enable = true;
      gopls.enable = true;
      gopls.settings = {
        completeUnimported = true;
        usePlaceholders = true;
      };

      htmx.enable = true;
      svelte.enable = true;
      tailwindcss.enable = true;
      eslint.enable = true;
      ts_ls.enable = true;
      cssls.enable = true;
      emmet_ls.enable = true;
      html.enable = true;

      csharp_ls.enable = true;

      sqls.enable = true;

      ansiblels.enable = true;
      dockerls.enable = true;

      marksman.enable = true;
      yamlls.enable = true;
      jsonls.enable = true;
      bashls.enable = true;
      lua_ls.enable = true;

      nil_ls.enable = true;
      nil_ls.settings.formatting.command = [
        "nixpkgs-fmt"
      ];
    };
  };

}
