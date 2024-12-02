{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraConfig = ''
      set number
    '';
  };
}