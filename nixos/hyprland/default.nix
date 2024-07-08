{ pkgs, lib, ... }:
{
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      WLR_DRM_NO_ATOMIC = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";

      GDK_SCALE = "2";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      NVD_BACKEND = "direct";
    };

    systemPackages = with pkgs; [
      pyprland
    ];
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
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = lib.mkDefault "considerate";
    };
    defaultSession = "hyprland";
  };
  services.xserver = {
    enable = true;
    dpi = 220;
  };
}
