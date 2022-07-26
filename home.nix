inputs: {
  colors = import ./colors;
  neovim = import ./neovim inputs.neovim;
  ranger = import ./ranger;
  tmux = import ./tmux;
  git = import ./git;
  shells = import ./shells;
  direnv = import ./direnv;
  deploy-cross-compass = import ./deploy-cross-compass;
  desktop = import ./desktop;
  st = import ./st;
  fonts = import ./fonts;
  autorandr = import ./autorandr;
  picom = import ./picom;
  highdpi = import ./highdpi;
  rofi = import ./rofi;
  wallpaper = import ./wallpaper;
  xmonad = import ./xmonad;
  chromium = import ./chromium;
  firefox = import ./firefox;
  spotify = import ./spotify;
  playerctld = import ./playerctld;
  sxiv = import ./sxiv;
  nnn = import ./nnn;
  go = import ./go;
  considerate = { lib, ... }: {
    home.sessionVariables = { EDITOR = "nvim"; };
    manual.manpages.enable = true;
    imports = [
      inputs.self.homeModules.go
      inputs.self.homeModules.colors
      inputs.self.homeModules.neovim
      inputs.self.homeModules.ranger
      inputs.self.homeModules.tmux
      inputs.self.homeModules.git
      inputs.self.homeModules.shells
      inputs.self.homeModules.direnv
      inputs.self.homeModules.deploy-cross-compass
      inputs.self.homeModules.desktop
      inputs.self.homeModules.st
      inputs.self.homeModules.fonts
      inputs.self.homeModules.autorandr
      inputs.self.homeModules.picom
      inputs.self.homeModules.highdpi
      inputs.self.homeModules.rofi
      inputs.self.homeModules.wallpaper
      inputs.self.homeModules.xmonad
      inputs.self.homeModules.chromium
      inputs.self.homeModules.firefox
      inputs.self.homeModules.spotify
      inputs.self.homeModules.playerctld
      inputs.self.homeModules.sxiv
      inputs.self.homeModules.nnn
    ];
  };
}
