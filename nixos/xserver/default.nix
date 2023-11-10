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
  services.xserver = {
    enable = true;
    dpi = 220;
    displayManager.autoLogin = {
      enable = true;
      user = "considerate";
    };
    displayManager.defaultSession = "hyprland";
    displayManager.session = [{
      manage = "window";
      name = "xmonad";
      start = ''
        ${pkgs.runtimeShell} $HOME/.xsession &
        waitPID=$!
      '';
    }];
  };
}
