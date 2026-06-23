{pkgs}: {
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
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
    prettierd

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
