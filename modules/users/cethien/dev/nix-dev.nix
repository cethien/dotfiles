{ lib, config, pkgs, ... }:

{
  options.user.dev.nix-dev.enable = lib.mkEnableOption "Enable nix develepment tools (nil, nixpkgs-fmt)";

  config = lib.mkIf config.user.dev.nix-dev.enable {
    home.packages = with pkgs; [
      nil
      nixpkgs-fmt
    ];
  };
}
