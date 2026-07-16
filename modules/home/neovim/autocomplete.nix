{pkgs}: let
  blink-cmp-qalc = pkgs.vimUtils.buildVimPlugin {
    name = "blink-cmp-qalc";
    src = ./plugins/blink-cmp-qalc;
    dependencies = [pkgs.vimPlugins.blink-cmp pkgs.libqalculate];
  };
  blink-cmp-pwd = pkgs.vimUtils.buildVimPlugin {
    name = "blink-cmp-pwd";
    src = ./plugins/blink-cmp-pwd;
    dependencies = [pkgs.vimPlugins.blink-cmp pkgs.genpass];
  };
in {
  initLua = builtins.readFile ./autocomplete.lua;

  extraPackages = with pkgs; [
    genpass
    libqalculate
  ];

  plugins = with pkgs.vimPlugins; [
    friendly-snippets

    blink-cmp
    blink-cmp-env
    blink-nerdfont-nvim
    blink-emoji-nvim
    blink-cmp-qalc
    blink-cmp-pwd

    blink-cmp-git
    blink-cmp-nixpkgs-maintainers
    blink-cmp-conventional-commits
    blink-cmp-latex
  ];
}
