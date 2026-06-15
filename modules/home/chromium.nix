{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.chromium;
  inherit (config.lib.deeznuts.hyprland) mkDefaultWorkspaceWindowRule;
in {
  options.programs.chromium = {
    autostart = mkEnableOption "chromium autostart";
    isDefault = mkEnableOption "set chromium as default browser";
  };

  config = mkIf cfg.enable {
    deeznuts.defaultBrowser = mkIf cfg.isDefault "chromium";

    programs.chromium = {
      extensions = [
        # ublock lite
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";}
        # decentraleyes
        {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";}
        # constant-o-matic
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";}
        # i still dont care about cookies
        {id = "edibdbjcniadpccecjdfdjjppcpchdlm";}
        # dont fuck with paste
        {id = "efaagigdgamehbpimpiagfpoihlkgamh";}
        # link cleaner
        {id = "pclbemffjpghlfbdjdifapggphgokeok";}

        # yet another flags
        {id = "dmchcmgddbhmbkakammmklpoonoiiomk";}

        # yang
        {id = "ecboojkidbdghfhifefbpdkdollfhicb";}
        # steamdb
        {id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon";}
        # Twitch Channel Points Auto Clicker
        {id = "jdpblpklojajpopllbckephjndibljbc";}
        # return youtube dislikes
        {id = "gebbhagfogifgggkldgodflihgfeippi";}
        # sponsorblock yt
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}

        # dark reader
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}

        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
      ];

      dictionaries = with pkgs.hunspellDictsChromium; [
        en_US
        de_DE
      ];

      commandLineArgs = [
        "--enable-logging=stderr"
        "--ignore-gpu-blocklist"
        "--restore-last-session"
        "--hide-crash-restore-bubble"
      ];
    };
  };
}
