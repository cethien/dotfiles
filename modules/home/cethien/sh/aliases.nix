{ config, system, user, ... }:

{
  home.shellAliases = {
    rebuild = ''
      ${if system.profile.isNixos then "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/.files#${system.host}" else ""}
      ${if system.profile.isWSL then "home-manager switch --flake ${config.home.homeDirectory}/.files#${user.username} -b bak-$(date +%y%m%d%H%M%S)" else ""}
    '';

    update = ''
      ${if system.profile.isWSL then "sudo nala update && sudo nala upgrade -y" else ""}
      (cd ${config.home.homeDirectory}/.files && nix flake update)
    '';

    clean = ''
      ${if system.profile.isWSL then "sudo nala autoremove" else ""}
      nix-store --gc
    '';

    reload = "source ${config.home.homeDirectory}/.bashrc && clear";
  };

}
