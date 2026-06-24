{pkgs}: {
  plugins = with pkgs.vimPlugins; [
    which-key-nvim
    nvim-sops
    mini-nvim
    toggleterm-nvim
    auto-session

    tokyonight-nvim
    tiny-cmdline-nvim

    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    friendly-snippets
    conform-nvim
  ];

  extraPackages = with pkgs; [
    emmet-language-server
    vscode-langservers-extracted
    marksman
    prettierd

    lua-language-server
    stylua

    bash-language-server
    shfmt
    yaml-language-server
    vscode-json-languageserver
    taplo
    lemminx
  ];

  initLua = ''
    ${builtins.readFile ./init.lua}
    ${builtins.readFile ./languages.lua}
    ${builtins.readFile ./autocomplete.lua}
    ${builtins.readFile ./ui.lua}
  '';
}
