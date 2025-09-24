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

  programs.wezterm.extraConfig =
    #lua
    ''
      return {
         hide_tab_bar_if_only_one_tab = true;
      }
    '';

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";

    bind = [
      "SUPER, Q, exec, $terminal"
    ];
  };
}
