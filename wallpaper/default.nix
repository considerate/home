{ pkgs, ... }:
{
  services.random-background = {
    enable = true;
    imageDirectory =
      let
        wallpapers = pkgs.runCommand "collect-wallpapers" { } ''
          mkdir $out
          cp ${pkgs.nixos-artwork.wallpapers.simple-dark-gray.kdeFilePath} $out
        ''; in
      "${wallpapers}";
  };
}
