{
  config = {
    programs.oh-my-posh.settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh/themes/cethien.omp.json)
    );
  };
}
