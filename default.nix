{ config, nixosConfig, pkgs, lib, ... }:
{
  imports = [
    ./base16
    ./neovim
    ./ranger
    ./tmux
    ./git
    ./bash
    ./emacs
    ./direnv
    ./deploy-cross-compass
  ] ++ lib.optionals nixosConfig.considerate.desktop [
    ./st
    ./autorandr
    ./compton
    ./highdpi
    ./rofi
    ./wallpaper
    ./xmonad
    ./chromium
    ./firefox
    ./spotify
  ];
  manual.manpages.enable = true;

  home.sessionVariables = { EDITOR = "nvim"; };
  home.stateVersion = "21.05";
}
