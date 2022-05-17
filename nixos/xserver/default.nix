{ pkgs, ... }:
{
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
