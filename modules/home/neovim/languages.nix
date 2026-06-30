{pkgs}: {
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context

    nvim-lspconfig
    conform-nvim
    otter-nvim

    go-nvim
    crates-nvim
    typst-preview-nvim
  ];

  extraPackages = with pkgs; [
    emmet-language-server
    vscode-langservers-extracted
    marksman
    prettierd
    lua-language-server
    stylua

    sqls

    bash-language-server
    shfmt
    yaml-language-server
    vscode-json-languageserver
    taplo
    lemminx
  ];

  initLua = builtins.readFile ./languages.lua;
}
