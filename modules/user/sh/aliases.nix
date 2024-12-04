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

    cd = "z";
    cat = "bat -p";
    ll = "eza -la --icons --group-directories-first --git";
    ls = "eza -1a --icons --group-directories-first --git";
    tree = "eza -T --icons";
    grep = "rg";
    find = "fd";
    duf = "df";
    ps = "procs";

    # git
    gs = "git status";
    gd = "git diff";
    ga = "git add";
    gaa = "git add .";
    gaf = "git add -f";

    gc = "git commit";
    gcm = "git commit -m";
    gcam = "git commit -am";

    gco = "git checkout";
    gcob = "git checkout -b";

    gcl = "git clone";
    gclb = "git clone --bare";

    gf = "git fetch";

    gpl = "git pull";

    gps = "git push";

    glg = "git log --graph --oneline --decorate";

    gwa = "git worktree add";
    gwl = "git worktree list";
    gwt = "git worktree prune";

    gss = "git stash";
    gsp = "git stash pop";

    init = "source $HOME/.user-scripts/init.sh";
  };

}