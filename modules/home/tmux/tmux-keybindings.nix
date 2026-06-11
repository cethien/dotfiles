{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;

  tmuxKeybindings = config.programs.tmux.keybindings or [];
  formatBind = binding: let
    table =
      if binding ? table
      then "-T ${binding.table} "
      else "";
    prefix =
      if binding.noprefix or false
      then "-n "
      else "";
    repeatable =
      if binding.repeat or false
      then "-r "
      else "";
    desc =
      if binding ? description
      then "-N \"${binding.description}\" "
      else "";
  in "bind ${table}${repeatable}${prefix}${desc}${binding.key} ${binding.action}";
in {
  options.programs.tmux = {
    keybindings = mkOption {
      type = types.listOf types.attrs;
      default = [];
    };
  };

  config = {
    programs.tmux = {
      extraConfig = ''
        ${lib.concatStringsSep "\n" (map formatBind tmuxKeybindings)}
      '';
    };
  };
}
