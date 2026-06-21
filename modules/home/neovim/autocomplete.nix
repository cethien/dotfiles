{pkgs}: let
  blink-cmp-qalc = pkgs.vimUtils.buildVimPlugin {
    name = "blink-cmp-qalc";
    src = ./plugins/blink-cmp-qalc;
    dependencies = [pkgs.vimPlugins.blink-cmp];
  };
in {
  initLua = builtins.readFile ./autocomplete.lua;

  extraPackages = with pkgs; [
    libqalculate
  ];

  plugins = with pkgs.vimPlugins; [
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
