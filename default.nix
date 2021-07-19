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
  ] ++ lib.optionals true [
    ./st
    ./fonts
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

  nixpkgs.config.allowUnfree = true;
  home.username = "viktor";
  home.homeDirectory = "/home/viktor";
  home.sessionVariables = { EDITOR = "nvim"; };
  home.stateVersion = "21.03";
}
