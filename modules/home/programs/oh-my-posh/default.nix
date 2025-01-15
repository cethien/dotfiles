{ lib, config, ... }:

{
  options.deeznuts.programs.oh-my-posh.enable = lib.mkEnableOption "Enable oh-my-posh";

  config = lib.mkIf config.deeznuts.programs.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./themes/cethien.omp.json));
    };
  };
}

