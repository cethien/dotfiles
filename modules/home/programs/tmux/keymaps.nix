{ lib, config, ... }:
let
  inherit (lib) mkIf mkBefore;
  tmuxKeybindings = config.programs.tmux.keybindings or [ ];

  formatBind = binding:
    let
      prefix = if binding.noprefix or false then "-n " else "";
    in
    "bind ${prefix}${binding.key} ${binding.action}";

in
{
  options = {
    programs.tmux.keybindings = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "List of tmux keybindings";
      default = [ ];
    };
  };

  config = mkIf config.programs.tmux.enable {
    programs.tmux.extraConfig = mkBefore ''
      ${lib.concatStringsSep "\n" (map formatBind tmuxKeybindings)}
    '';
  };
}

