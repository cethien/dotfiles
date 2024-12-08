{ ... }:

{
  programs.git = {
    enable = true;
    userName = "cethien";
    userEmail = "borislaw.sotnikow@gmx.de";

    aliases = {
      ignore = "!gi() { curl -fsSL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
    };

    extraConfig = {
      core = {
        eol = "lf";
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      advice = {
        addIgnoredFile = false;
      };
    };

    diff-so-fancy.enable = true;
  };
}