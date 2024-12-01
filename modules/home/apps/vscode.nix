{ pkgs, ... }:

{
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
}