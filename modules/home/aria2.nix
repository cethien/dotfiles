{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  # inherit (config.lib.zen-browser) mkExtensionSettings;
  cfg = config.programs.aria2;
  uname = "${config.home.username}";
  addons = pkgs.firefox-addons;
in {
  config = mkIf cfg.enable {
    programs.aria2 = {
      systemd.enable = true;
      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
        enable-rpc = true;
        seed-time = 0;
      };
    };

    programs.zen-browser = {
      profiles."${uname}".extensions.packages = [addons.aria2-integration];
      # policies.ExtensionSettings = mkExtensionSettings {
      #   "baptistecdr@users.noreply.github.com" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/file/4836651/aria2_extension-4.13.6.xpi";
      #     installation_mode = "force_installed";
      #   };
      # };
    };
  };
}
