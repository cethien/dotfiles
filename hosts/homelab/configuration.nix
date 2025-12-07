{
  imports = [
    ../../modules/nixos
  ];

  services.openssh.enable = true;

  users.users.cethien.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.swarm.enable = true;

  services = {
    # promtail.enable = true;
    promtail.configuration.clients = [
      {
        url = "https://loki.cethien.home/loki/api/v1/push";
        tls_config.insecure_skip_verify = true;
      }
    ];
    cadvisor.enable = true;

    prometheus = {
      exporters = {
        node.enable = true;
        systemd.enable = true;
      };
    };
  };

  deeznuts = {
    deployrs = {
      enable = true;
      user = {
        passwordHash = ''$y$j9T$r2684bTnOr2UlMD6bUE7h.$biexUINB5jwsH.1Mhv3YCF8qV9E9qhJTjUbZ6KkGL/6'';
        keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaT7VoC4pEM8lE/R11qqYeZl3SgHZRSR9PGntkAwOC/ deployrs@cethien.home''
        ];
      };
    };
  };
}
