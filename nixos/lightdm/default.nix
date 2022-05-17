{ pkgs, ... }:
{
  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      extraConfig = ''
        xserver-command=X -dpi 220
        xft-dpi=220
      '';
    };
  };
}
