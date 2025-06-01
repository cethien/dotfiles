{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.pim.thunderbird;
in {
  options.deeznuts.programs.pim.thunderbird.enable = mkEnableOption "thunderbird";

  config = let
    email.primary = config.deeznuts.programs.pim.email.email.primary;
  in
    mkIf cfg.enable {
      programs.thunderbird.enable = true;
      accounts.email.accounts."${email.primary}".thunderbird.enable = true;
      programs.thunderbird.profiles = {
        "${email.primary}" = {
          isDefault = true;
        };
      };
    };
}
