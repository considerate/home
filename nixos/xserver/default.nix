{ pkgs, lib, ... }:
{
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };
  # Wayland hyperland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  fonts.fontconfig.antialias = lib.mkDefault true;
  fonts.fontconfig.subpixel = {
    rgba = lib.mkDefault "none";
    lcdfilter = lib.mkDefault "none";
  };
  security.pam.services.swaylock = { };
  services.gnome.gnome-keyring.enable = lib.mkForce true;
  services.xserver = {
    enable = true;
    dpi = 220;
    desktopManager.gnome.enable = true;
    displayManager.autoLogin = {
      enable = true;
      user = lib.mkDefault "considerate";
    };
    displayManager.defaultSession = "hyprland";
  };
}
