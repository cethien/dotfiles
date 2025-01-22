{
  normal = {
    space.space = "file_picker";
    space.q = ":q";
    esc = [ "collapse_selection" "keep_primary_selection" ];
    C-s = ":w";
    C-g = [ ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ];
    A-down = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
    A-up = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
  };
}
