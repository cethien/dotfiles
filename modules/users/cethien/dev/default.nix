{ lib, config, ... }:

{
  imports = [
    ./nix-dev.nix

    ./make.nix
    ./just.nix
    ./quicktype.nix

    ./go.nix
    ./bun.nix

    ./ansible.nix

    ./act.nix
  ];

  options.user.dev.enable = lib.mkEnableOption "Enable dev";

  config = lib.mkIf config.user.dev.enable {
    user.dev.nix-dev.enable = true;

    user.dev.make.enable = true;
    user.dev.just.enable = true;
    user.dev.quicktype.enable = true;

    user.dev.go.enable = true;
    user.dev.bun.enable = true;

    user.dev.ansible.enable = true;

    user.dev.act.enable = true;
  };
}