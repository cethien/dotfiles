{ pkgs, ... }:

{
  home.packages = with pkgs; [ lazydocker ];

  home.shellAliases.ldocker = "lazydocker";
}
