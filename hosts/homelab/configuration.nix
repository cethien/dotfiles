{
  imports = [
    ./disko.nix
    ./home-assistant.nix
    ./homepage
    ./your-spotify.nix
  ];

  config = {
    services.caddy.cloudflare-tls.enable = true;
    services.caddy.openFirewall = true;
  };
}
