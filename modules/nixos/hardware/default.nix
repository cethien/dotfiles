{lib, ...}:
with lib; {
  imports = [
    ./nvidia-gpu.nix
    ./logitech-peripherals.nix
    ./elgato-stream-deck.nix
  ];

  options.deeznuts.hardware = mkOption {
    type = types.listOf types.str;
    default = [];
    description = "list of hardware extras";
  };
}
