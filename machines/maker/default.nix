inputs:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    inputs.self.nixosModules.tabby
    inputs.self.nixosModules.battery
    inputs.self.nixosModules.docker
    inputs.self.nixosModules.boot
    inputs.self.nixosModules.i18n
    inputs.self.nixosModules.network
    inputs.self.nixosModules.nix
    inputs.self.nixosModules.packages
    inputs.self.nixosModules.passwords
    inputs.self.nixosModules.powerline
    inputs.self.nixosModules.redshift
    inputs.self.nixosModules.tex
    inputs.self.nixosModules.trackpad
    inputs.self.nixosModules.hyprland
    inputs.self.nixosModules.display-manager
    ({ pkgs, ... }: {
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        zlib
        nss
        openssl
        curl
        expat
      ];
    })
    ({ pkgs, ... }: {
      services.flatpak.enable = true;
      # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.config.common.default = "gtk";
    })
    {
      nix.settings.trusted-users = [ "root" "@wheel" ];
      users.users.viktor.extraGroups = [ "docker" ];
    }
    ({ pkgs, config, ... }:
      let
        unstable = import inputs.unstable {
          system = pkgs.stdenv.system;
          config.allowUnfree = true;
        };
      in
      {
        services.xserver.videoDrivers = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        boot.kernelPackages = unstable.linuxPackages_latest;
        hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
        boot.kernelParams = [
          "nvidia.NVReg_PreserveVideoMemoryAllocations=1"
          "nvidia-drm.modeset=1"
          "nvidia-drm.fbdev=1"
        ];
        hardware.nvidia.powerManagement.enable = true;
        hardware.nvidia.open = false;
      })
    {
      age.identityPaths = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    }
    ({ lib, ... }: {
      nix.registry = lib.mapAttrs (name: flake: { inherit flake; }) {
        inherit (inputs) nixpkgs home-manager;
      };
    })
    ({ pkgs, lib, ... }: {
      programs.fish.enable = true;
      users = {
        users = {
          viktor = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            shell = pkgs.fish;
          };
        };
        groups.considerate = { };
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = ".bak";
        users = {
          viktor =
            let
              nix-index = {
                programs.nix-index.enable = true;
              };
            in
            {
              imports = [
                nix-index
                inputs.self.homeModules.considerate
                inputs.hyprland.homeManagerModules.default
              ];
              considerate.desktop = true;
            };
        };
      };
    })
    {
      networking = {
        hostName = "maker";
        domain = "xc";
        defaultGateway = "192.168.1.1";
        networkmanager.enable = true;
        firewall.allowedUDPPortRanges = [
          { from = 50000; to = 60000; } # UE multi-user-server
        ];
        firewall.allowedTCPPorts = [ 3000 3200 5000 8080 6006 6007 6008 3389 5900 5901 5902 ];
        firewall.allowedUDPPorts = [ 5568 5569 ];
      };
    }
    ({ pkgs, ... }: {
      hardware.opengl.enable = true;
      programs.hyprland.enable = true;
      programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    })
    {
      location = {
        latitude = 35.0;
        longitude = 139.0;
      };
    }
  ];
}
