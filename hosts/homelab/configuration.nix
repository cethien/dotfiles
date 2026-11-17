{
  imports = [
    ./disko.nix
    ./home-assistant.nix
    ./homepage
  ];

  config = {
    services.caddy.cloudflare-tls.enable = true;
    services.caddy.openFirewall = true;
  };
}
