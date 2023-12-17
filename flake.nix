{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = inputs: {
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
  };
}
