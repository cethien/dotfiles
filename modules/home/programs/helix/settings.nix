{
  keys = import ./keys.nix;

  editor = {
    line-number = "absolute";
    cursorline = true;
    color-modes = true;

    soft-wrap.enable = true;

    auto-save = {
      focus-lost = true;
      after-delay.enable = true;
    };

    indent-guides = {
      character = "┊";
      render = true;
      skip-levels = 1;
    };

    lsp = {
      display-inlay-hints = true;
      display-messages = true;
    };

    cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };
  };
}
