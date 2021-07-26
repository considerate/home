{ pkgs, lib, config, ... }:
{
  services.picom = {
    enable = config.considerate.desktop;
    package = pkgs.picom.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        repo = "picom";
        owner = "yshui";
        rev = "d974367a0446f4f1939daaada7cb6bca84c893ef";
        sha256 = "0mjm544vck493sdcvr90d9ycg5sxin28a13w61q1kqkycilv87lv";
      };
    });
    experimentalBackends = true;
    vSync = true;
    shadow = true;
    fade = true;
    fadeDelta = 4;
    inactiveDim = "0.20";
    opacityRule = [ "100:class_i != 'st-256color'" ];
    blurExclude = [ "class_i != 'st-256color'" ];
  };
}
