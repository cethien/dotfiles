{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zen-browser.enable = true;
  programs.browser.default = config.programs.zen-browser.package;
  programs.zen-browser.profiles."${config.home.username}" = let
    containers = {
      logged-out = {
        id = 1;
        color = "toolbar";
        icon = "chill";
      };
      admin = {
        id = 2;
        color = "pink";
        icon = "circle";
      };
    };

    spaces."deez nuts" = {
      id = "cd0b7a9b-bb11-42e8-a10a-52ea6813e6b4";
      position = 1000;
      icon = "🥙";
    };

    pins = {
      "whatsapp" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        url = "https://web.whatsapp.com/";
        isEssential = true;
        position = 101;
      };
      "calendar" = {
        id = "591c45e0-737f-47d1-86e8-bf173ce87df9";
        url = "https://calendar.google.com";
        isEssential = true;
        position = 102;
      };

      "youtube" = {
        id = "217cf342-d929-419b-9a41-75ed87239d99";
        url = "https://www.youtube.com/feed/subscriptions";
        position = 1001;
      };
    };
  in {
    containersForce = true;
    inherit containers;
    pinsForce = true;
    inherit pins;
    spacesForce = true;
    inherit spaces;
  };
}
