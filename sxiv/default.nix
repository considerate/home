{ pkgs, ... }:
{
  home.packages = [ pkgs.sxiv ];
  xresources.extraConfig = ''
    Sxiv.font: FiraCode Nerd Font
  '';
}
