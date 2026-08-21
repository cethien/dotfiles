{
  pkgs,
  pkgs-unstable,
  ...
}: let
  blink-cmp-qalc = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "blink-cmp-qalc";
    src = ./plugins/blink-cmp-qalc;
    dependencies = [pkgs-unstable.vimPlugins.blink-cmp];
  };
in {
  initLua = builtins.readFile ./autocomplete.lua;

  extraPackages = [pkgs-unstable.libqalculate];

  plugins = with pkgs-unstable.vimPlugins; [
    friendly-snippets

    blink-cmp
    blink-cmp-env
    blink-nerdfont-nvim
    blink-emoji-nvim
    blink-cmp-qalc

    blink-cmp-git
    blink-cmp-nixpkgs-maintainers
    blink-cmp-conventional-commits
    blink-cmp-latex
  ];
}
