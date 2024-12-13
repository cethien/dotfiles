{ ... }:

{
  programs.eza.enable = true;

  home.shellAliases = {
    ll = "eza -la --icons --group-directories-first --git";
    ls = "eza -1a --icons --group-directories-first --git";
    tree = "eza -T --icons";
  };
}