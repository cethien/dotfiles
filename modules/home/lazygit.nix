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
                title = "select license";
                key = "License";
                command = "${pkgs.license-go}/bin/license -list";
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
  };
}
