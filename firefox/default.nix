{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = config.considerate.desktop;
  };
}
