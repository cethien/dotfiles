{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.vscode;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.vscode = {
    enable = mkEnableOption "Enable VSCode";
  };

  config = mkIf cfg.enable {
    stylix.targets.vscode.enable = false;
    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; [
        vscode-icons-team.vscode-icons

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
