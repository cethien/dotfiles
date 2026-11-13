{config, ...}: {
  sops.secrets = {
    "tms/tailscale/auth_key" = {};
    "tms/tailscale/tailnet" = {};
  };

  home.sessionVariables = {
    TAILSCALE_API_KEY = "$(cat ${config.sops.secrets."tms/tailscale/auth_key".path})";
    TAILSCALE_TAILNET = "$(cat ${config.sops.secrets."tms/tailscale/tailnet".path})";
  };
}
