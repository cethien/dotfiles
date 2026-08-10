{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.lazygit;

  tmux-editor =
    pkgs.writeShellScriptBin "tmux-editor"
    # bash
    ''
      if [ -n "$TMUX" ]; then
        branch_name=$(git branch --show-current 2>/dev/null)
        window_title="$EDITOR"
        if [ -n "$branch_name" ]; then
          window_title="$EDITOR/''${branch_name}"
        fi
        tmux new-window -a -n "$window_title" "$EDITOR $*"
      else
        exec $EDITOR "$@"
      fi
    '';
in {
  config = mkIf cfg.enable {
    programs.lazygit = {
      shellWrapperName = "lzg";
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#overriding-default-config-file-location
      settings = {
        gui = {
          sidePanels = [
            ["files" "worktrees"]
            ["commits"]
            ["status" "branches" "remotes"]
            ["stash"]
          ];

          showCommandLog = false;
          showRandomTip = false;
          showBottomLine = false;
          timeFormat = "2006-01-02";
          shortTimeFormat = "15:04";
        };
        update.method = "never";
        disableStartupPopups = true;
        notARepository = "prompt";
        promptToReturnFromSubprocess = false;

        os.openDirInEditor = "${tmux-editor}/bin/tmux-editor";

        customCommands = let
          license = "${pkgs.license-go}/bin/license";
        in [
          {
            key = "l";
            description = "Add LICENSE file";
            context = "files";
            command = "${license} -o LICENSE {{.Form.License}}";
            prompts = [
              {
                type = "menuFromCommand";
                title = "select license";
                key = "License";
                command = "${license} -list";
                filter = "^(?P<id>\\S+)\\s+(?P<desc>.*)";
                valueFormat = "{{ .id }}";
                labelFormat = "{{ .id | yellow }} {{ .desc | cyan }}";
              }
            ];
          }
          {
            key = "<f1>";
            description = "Show code statistics";
            command = "${pkgs.scc}/bin/scc --no-cocomo --no-size";
            context = "global";
            output = "popup";
            outputTitle = "Stats";
          }
        ];
      };
    };

    programs.tmux.resurrectPluginProcesses = ["lazygit"];

    programs.neovim = {
      initLua =
        # lua
        ''
          local lazygit = require("floatty").setup({
              cmd = "lazygit",
              id = vim.fn.getcwd,
              window = {
          				width = 0.975,
                  height = 0.9,
              },
          })

          vim.keymap.set("n", "<C-g>", function()
          	lazygit.toggle()
          end)
          vim.keymap.set("t", "<C-g>", function()
          	lazygit.toggle()
          end)
        '';
    };
  };
}
