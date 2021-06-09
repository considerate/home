{ pkgs, lib, config, ... }:
{
  services.picom = {
    enable = true;
    vSync = true;
    shadow = true;
    fade = true;
    fadeDelta = 4;
    inactiveDim = "0.20";
    opacityRule = [ "100:class_i != 'st-256color'" ];
    blurExclude = [ "class_i != 'st-256color'" ];
  };
}
