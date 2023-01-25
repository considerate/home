{ pkgs, lib, ... }:
{
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };
  fonts.fontconfig.antialias = lib.mkDefault true;
  fonts.fontconfig.subpixel = {
    rgba = lib.mkDefault "none";
    lcdfilter = lib.mkDefault "none";
  };
  services.xserver = {
    enable = true;
    dpi = 220;
    displayManager.autoLogin = {
      enable = true;
      user = "considerate";
    };
    displayManager.defaultSession = "none+xmonad";
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
