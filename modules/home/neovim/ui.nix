{pkgs}: {
  initLua = builtins.readFile ./ui.lua;

  plugins = with pkgs.vimPlugins; [
    tokyonight-nvim
    blink-cmp
    tiny-cmdline-nvim
  ];

  extraPackages = [];
}
