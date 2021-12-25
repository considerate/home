{ pkgs, lib, config, ... }:
{
  home.packages = lib.mkIf config.considerate.desktop [ pkgs.spotify ];
}
