{ pkgs, lib, config, ... }:
{
  services.picom = {
    enable = config.considerate.desktop;
    shadow = true;
    fade = true;
    fadeDelta = 4;
    inactiveDim = "0.20";
  };
}
