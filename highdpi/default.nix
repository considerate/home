{ pkgs, lib, ... }: {
  xresources.extraConfig = ''
    Xft.dpi: 220
    xterm*faceName: xft:FiraCode Nerd Font:pixelsize=32
  '';
}
