{
  imports = [
    ../../modules/nixos
  ];

  networking.hostName = "homelab";

  deeznuts = {
    ansible = {
      enable = true;
      user = {
        passwordHash = ''$y$j9T$Sb/HaF3.s2MzZa6a303.P1$s1zqCQkZVBWM.k/AC0PN6eYuheeS8vd345vRco8SHK'';
        keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIComNrX0wHUEL5YG/cC2XFCC/FZKWdrgkRKlZVXk3Kfo ansible@cethien.home''
        ];
      };
    };
    deployrs = {
      enable = true;
      user = {
        passwordHash = ''$y$j9T$r2684bTnOr2UlMD6bUE7h.$biexUINB5jwsH.1Mhv3YCF8qV9E9qhJTjUbZ6KkGL/6'';
        keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaT7VoC4pEM8lE/R11qqYeZl3SgHZRSR9PGntkAwOC/ deployrs@cethien.home''
        ];
      };
    };
    virtualisation.docker = {
      enable = true;
      swarm.enable = true;
      users = ["cethien"];
    };
  };
}
