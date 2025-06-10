{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.ai;
in {
  options.deeznuts.ai = {
    enable = mkEnableOption "local AI";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      loadModels = [
        "phi3:mini"
        "mistral"
        "codellama:7b-instruct"
      ];
    };
  };
}
