inputs: {
  colors = import ./colors;
  neovim = import ./neovim;
  ranger = import ./ranger;
  tmux = import ./tmux;
  git = import ./git;
  shells = import ./shells;
  direnv = import ./direnv;
  desktop = import ./desktop;
  fonts = import ./fonts;
  autorandr = import ./autorandr;
  picom = import ./picom;
  highdpi = import ./highdpi;
  rofi = import ./rofi;
  wallpaper = import ./wallpaper;
  xmonad = import ./xmonad;
  firefox = import ./firefox;
  spotify = import ./spotify;
  playerctld = import ./playerctld;
  sxiv = import ./sxiv;
  nnn = import ./nnn;
  go = import ./go;
  hyprland = import ./hyprland;
  vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
      ];
    };
  };
  considerate = { lib, ... }: {
    home.sessionVariables = { EDITOR = "nvim"; };
    home.stateVersion = "22.11";
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
      inputs.self.homeModules.desktop
      inputs.self.homeModules.fonts
      inputs.self.homeModules.autorandr
      inputs.self.homeModules.highdpi
      inputs.self.homeModules.rofi
      inputs.self.homeModules.wallpaper
      inputs.self.homeModules.spotify
      inputs.self.homeModules.playerctld
      inputs.self.homeModules.sxiv
      inputs.self.homeModules.nnn
      inputs.self.homeModules.hyprland
    ];
  };
}
