{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:neovim/neovim/v0.7.0?dir=contrib";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    {
      nixosModules = import ./nixos inputs;
      homeModules = import ./home.nix inputs;
      homeConfigurations = {
        considerate = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/considerate";
          username = "considerate";
          stateVersion = "22.05";
          configuration = inputs.self.homeModules.considerate;
        };
      };
      nixosConfigurations = {
        considerate-nixos = import machines/considerate-nixos.nix inputs;
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
    };
}
