{ ... }:

{
  programs.fastfetch = {
    enable = true;
  };

  home.shellAliases = {
    neofetch = "fastfetch";
  };
}
