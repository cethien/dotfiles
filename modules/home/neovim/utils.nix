{pkgs}: {
  extraPackages = [];
  plugins = with pkgs.vimPlugins; [
    octo-nvim
    nvim-sops
    csvview-nvim
    lorem-nvim
  ];

  initLua = builtins.readFile ./utils.lua;
}
