{lib, ...}: let
  inherit (lib) mkDefault;
in {
  services.ollama = {
    enable = mkDefault false;
    loadModels = [
      "phi3:mini"
      "mistral"
      "codellama:7b-instruct"
    ];
  };
}
