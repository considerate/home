{ pkgs, ... }:
{
  home.file = {
    wallpapers = {
      source = ./wallpapers;
      target = ".wallpapers";
    };
    nixos-wallpaper = {
      source = pkgs.nixos-artwork.wallpapers.simple-dark-gray.kdeFilePath;
      target = ".wallpapers/nixos.png";
    };
  };
}
