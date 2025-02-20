{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };
  outputs = inputs: {
    nixosModules = import ./nixos inputs;
    homeModules = import ./home.nix inputs;
    homeConfigurations = {
      considerate = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            home = {
              username = "considerate";
              homeDirectory = "/home/considerate";
            };
          }
          inputs.self.homeModules.considerate
        ];
      };
    };
    nixosConfigurations = {
      considerate-nixos = import machines/considerate-nixos.nix inputs;
      maker = import machines/maker inputs;
    };
  };
}
