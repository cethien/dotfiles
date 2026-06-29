{
  config,
  pkgs,
}: {
  profiles."${config.home.username}" = let
    zen =
      import ../_tms/home/zen-browser.nix {inherit pkgs;};
  in {
    bookmarks = {
      force = true;
      settings = zen.bookmarks;
    };

    extensions.packages = zen.extensions;

    containersForce = true;
    containers = {
      logged-out = {
        id = 1;
        color = "blue";
        icon = "chill";
      };
      admin = {
        id = 2;
        color = "purple";
        icon = "circle";
      };
      "tailscale/member" = {
        id = 3;
        color = "yellow";
        icon = "vacation";
      };
      "tailscale/admin" = {
        id = 4;
        color = "orange";
        icon = "vacation";
      };
      "private" = {
        id = 5;
        color = "green";
        icon = "fence";
      };
    };

    spaces."lets get this bread" = {
      id = "8e725798-defd-4b13-bc8b-ae3fd4bad512";
      position = 1000;
      icon = "🍞";
    };

    pins = {
      "admin" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        url = "https://admin.tmspro.shop/";
        position = 1010;
        isEssential = true;
      };
      "tmspro.shop" = {
        id = "96070d37-4b78-490f-87d1-884474bd9434";
        url = "https://tmspro.shop";
        position = 1011;
        isEssential = true;
      };

      "proxmox" = {
        id = "81af52ca-b49b-4feb-89b5-20ae325309aa";
        url = "https://10.0.10.5:8006";
        position = 110;
      };
      "pve-node-c" = {
        id = "84a572b9-77e0-4d70-a96d-590d95d5148a";
        url = "https://10.0.10.7:8006";
        position = 111;
      };
    };
  };
}
