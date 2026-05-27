{
  imports = [
    ../_common/configuration.nix
  ];

  config = {
    virtualisation.docker.enable = true;

    deployrs.user = {
      passwordHash = ''$y$j9T$r2684bTnOr2UlMD6bUE7h.$biexUINB5jwsH.1Mhv3YCF8qV9E9qhJTjUbZ6KkGL/6'';
      keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaT7VoC4pEM8lE/R11qqYeZl3SgHZRSR9PGntkAwOC/ deployrs@cethien.home''
      ];
    };
  };
}
