{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cavemanSrc = import ../../packages/caveman-skill.nix {inherit pkgs;};
in {
  config = lib.mkIf config.programs.opencode.enable {
    programs.opencode = {
      package = pkgs-unstable.opencode;
      skills = {
        caveman = "${cavemanSrc}/skills/caveman";
      };
    };

    programs.tmux.resurrectPluginProcesses = ["opencode"];

    programs.neovim = {
      initLua =
        # lua
        ''
          local opencode = require("floatty").setup({
          	cmd = "opencode",
          	id = vim.fn.getcwd,
          	window = {
          		h_align = "right",
          		width = 0.5,
          		height = 1,
          	},
          })

          vim.keymap.set("n", "<C-k>", function()
          	opencode.toggle()
          end)
          vim.keymap.set("t", "<C-k>", function()
          	opencode.toggle()
          end)
        '';
    };
  };
}
