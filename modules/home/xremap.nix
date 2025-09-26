{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.xremap.homeManagerModules.default
  ];

  services.xremap = {
    withWlroots = config.wayland.windowManager.hyprland.enable;
    withGnome = config.programs.gnome-shell.enable;
  };
}
