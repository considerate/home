{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    let
      configuration = { lib, ... }: {
        home.sessionVariables = { EDITOR = "nvim"; };
        manual.manpages.enable = true;
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
          ./desktop
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
          ./playerctld
          ./sxiv
        ];
      };
    in
    {
      nixosModules.considerate = configuration;
      homeConfigurations = {
        considerate = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/considerate";
          username = "considerate";
          stateVersion = "21.05";
          inherit configuration;
        };
      };
    };
}
