{
  programs.kitty = {
    settings = {
      window_padding_width = 2;
      update_check_interval = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
    keybindings = {
      "ctrl+shift+g" = "no_op";
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";

    bind = [
      "SUPER, RETURN, exec, $terminal"
    ];
  };
}
