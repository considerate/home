{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:neovim/neovim/v0.7.0?dir=contrib";
  };
  outputs = inputs:
    {
      homeModules = {
        colors = import ./colors;
        neovim = import ./neovim inputs.neovim;
        ranger = import ./ranger;
        tmux = import ./tmux;
        git = import ./git;
        bash = import ./bash;
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
        considerate = { lib, ... }: {
          home.sessionVariables = { EDITOR = "nvim"; };
          manual.manpages.enable = true;
          imports = [
            inputs.self.homeModules.colors
            inputs.self.homeModules.neovim
            inputs.self.homeModules.ranger
            inputs.self.homeModules.tmux
            inputs.self.homeModules.git
            inputs.self.homeModules.bash
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
      };
      apps =
        let
          pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
          };
          deploy-cross-compass = pkgs.callPackage ./deploy-cross-compass/deploy.nix {
            machines = [
              "jarjar.xc"
              "chewbacca.xc"
              "anakin.xc"
              "pichanaki.xc"
              "bobafett.xc"
            ];
          };
        in
        {
          x86_64-linux = {
            deploy-cross-compass = {
              type = "app";
              program = "${deploy-cross-compass}/bin/deploy-cross-compass";
            };
          };
        };
      homeConfigurations = {
        considerate = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/considerate";
          username = "considerate";
          stateVersion = "21.05";
          configuration = inputs.self.homeModules.considerate;
        };
      };
    };
}
