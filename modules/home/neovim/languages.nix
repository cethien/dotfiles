{
  pkgs,
  pkgs-unstable,
}: {
  plugins = with pkgs-unstable.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context

    nvim-lspconfig
    conform-nvim
    otter-nvim

    go-nvim
    crates-nvim
    typst-preview-nvim
  ];

  extraPackages = with pkgs-unstable; [
    emmet-language-server
    vscode-langservers-extracted
    marksman
    prettierd
    tailwindcss-language-server

    lua-language-server
    stylua

    sqls

    bash-language-server
    shfmt
    yaml-language-server
    vscode-json-languageserver
    taplo
    lemminx

    nixd
    alejandra
  ];

  initLua = builtins.readFile ./languages.lua;
}
