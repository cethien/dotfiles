{pkgs}: {
  initLua = builtins.readFile ./ui.lua;

  plugins = with pkgs.vimPlugins; [
    tokyonight-nvim
    tiny-cmdline-nvim
  ];

  extraPackages = [];
}
