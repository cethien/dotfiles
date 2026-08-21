{
  pkgs,
  pkgs-unstable,
}: {
  initLua = builtins.readFile ./ui.lua;

  plugins = with pkgs-unstable.vimPlugins; [
    tokyonight-nvim
    tiny-cmdline-nvim
  ];

  extraPackages = [];
}
