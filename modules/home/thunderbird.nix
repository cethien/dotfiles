{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.thunderbird = {
      languagePacks = ["en-US" "en-GB" "de"];
    };
  };
}
