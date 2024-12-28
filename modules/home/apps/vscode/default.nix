{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.vscode;
in
{
  options.deeznuts.apps.vscode = {
    enable = mkEnableOption "Enable VSCode";
  };

  config = mkIf cfg.enable {
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

        arrterian.nix-env-selector
        jnoortheen.nix-ide
        mkhl.direnv
        jeff-hykin.better-nix-syntax

        nefrob.vscode-just-syntax
      ];
    };
  };
}
