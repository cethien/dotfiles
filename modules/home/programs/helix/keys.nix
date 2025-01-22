{
  normal = {
    esc = [ "collapse_selection" "keep_primary_selection" ];
    space.space = "file_picker";
    space.q = ":q";
    C-s = ":w";

    A-down = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
    A-up = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];

    C-S-g = [ ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ];
  };
}
