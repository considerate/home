{ pkgs, config, ... }:
{
  services.random-background = {
    enable = config.considerate.desktop;
    imageDirectory =
      let
        wallpapers = pkgs.runCommand "collect-wallpapers" { } ''
          mkdir $out
          cp ${pkgs.nixos-artwork.wallpapers.simple-dark-gray.kdeFilePath} $out
        ''; in
      "${wallpapers}";
  };
}
