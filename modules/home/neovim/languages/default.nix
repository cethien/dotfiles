{pkgs}: {
  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    conform-nvim
    crates-nvim
    typst-preview-nvim
  ];

  extraPackages = with pkgs; [
    emmet-language-server
    vscode-langservers-extracted
    prettierd

    bash-language-server
    shfmt
    yaml-language-server
    vscode-json-languageserver
    taplo
    lemminx
  ];

  initLua = builtins.readFile ./languages.lua;
}
