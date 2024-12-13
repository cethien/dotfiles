{ system, user,... }:

{
  home.shellAliases = {
    rebuild = ''
      ${if system.profile.isNixos then "sudo nixos-rebuild switch --flake $HOME/.files#${system.host}" else ""}
      ${if system.profile.isWSL then "home-manager switch --flake $HOME/.files#${user.username} -b bak-$(date +%y%m%d%H%M%S)" else ""}
    '';

    update = ''
      ${if system.profile.isWSL then "sudo nala update && sudo nala upgrade -y" else ""}
      (cd $HOME/.files && nix flake update)
    '';

    clean = ''
      ${if system.profile.isWSL then "sudo nala autoremove" else ""}
      nix-store --gc
    '';

    reload = "source $HOME/.bashrc && clear";
    
    init = "source $HOME/.user-scripts/init.sh";
  };

}