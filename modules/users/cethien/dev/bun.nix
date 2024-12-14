{ lib, config, ... }:

{
  options.user.dev.bun.enable = lib.mkEnableOption "Enable bun";

  config = lib.mkIf config.user.dev.bun.enable {
    programs.bun.enable = true;
  };
}
