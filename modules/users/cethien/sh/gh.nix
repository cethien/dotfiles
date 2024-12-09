{ ... }:

{
  programs.gh.enable = true;

  programs.gh.settings =  {
    git_protocol = "ssh";

    prompt = "enable";
  };
}
