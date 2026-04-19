{
  programs.kitty = {
    settings = {
      clear_all_shortcuts = "yes";
      window_padding_width = 2;
      update_check_interval = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      "ctrl+shift+up" = "no_op";
      "ctrl+shift+down" = "no_op";
      "ctrl+shift+left" = "no_op";
      "ctrl+shift+right" = "no_op";
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";

    bind = [
      "SUPER SHIFT, RETURN, exec, $terminal"
    ];
  };
}
