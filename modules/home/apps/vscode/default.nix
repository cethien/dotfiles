{ lib, config, pkgs, ... }:

{
  options.apps.vscode.enable = lib.mkEnableOption "Enable VSCode";

  config = lib.mkIf config.apps.vscode.enable {
    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; [
        vscode-icons-team.vscode-icons
        catppuccin.catppuccin-vsc

        mads-hartmann.bash-ide-vscode
        foxundermoon.shell-format
        timonwong.shellcheck
        esbenp.prettier-vscode
        tamasfe.even-better-toml
        redhat.vscode-yaml
        redhat.vscode-xml

        jnoortheen.nix-ide
      ];
    };
  };
}
