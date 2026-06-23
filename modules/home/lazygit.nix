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
        branch_name=$(${pkgs.git}/bin/git branch --show-current 2>/dev/null)
        window_title="nvim"
        if [ -n "$branch_name" ]; then
          window_title="nvim:''${branch_name}"
        fi
        ${pkgs.tmux}/bin/tmux new-window -n "$window_title" "${pkgs.neovim}/bin/nvim $*"
      else
        exec ${pkgs.neovim}/bin/nvim "$@"
      fi
    '';
in {
  config = mkIf cfg.enable {
    programs.lazygit = {
      shellWrapperName = "lzg";
      settings = {
        update.method = "never";
        disableStartupPopups = true;
        notARepository = "quit";
        promptToReturnFromSubprocess = false;

        os.openDirInEditor = "${tmux-editor}/bin/tmux-editor";

        customCommands = [
          {
            key = "l";
            description = "Add LICENSE file";
            context = "files";
            command = "${pkgs.license-go}/bin/license -o LICENSE {{.Form.License}}";
            prompts = [
              {
                type = "menuFromCommand";
                title = "Select License";
                key = "License";
                command = "${pkgs.license-go}/bin/license -list";
                filter = "^(?P<id>\\S+)\\s+(?P<desc>.*)";
                valueFormat = "{{ .id }}";
                labelFormat = "{{ .id | yellow }} {{ .desc | cyan }}";
              }
            ];
          }
          {
            key = "<f3>";
            description = "open gh-dash";
            command = "${pkgs.gh-dash}/bin/gh-dash";
            context = "global";
            output = "terminal";
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
  };
}
