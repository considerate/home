inputs:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    inputs.self.nixosModules.battery
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
    inputs.self.nixosModules.xserver
    inputs.self.nixosModules.display-manager
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
        users = {
          viktor =
            let
              hyprland-maker = {
                wayland.windowManager.hyprland.settings = {
                  # change monitor to high resolution, the last argument is the scale factor
                  xwayland.force_zero_scaling = true;
                  monitor = ",highres,auto,2";
                  env =
                    [
                      "GDK_SCALE,2"
                      "XCURSOR_SIZE,32"
                      "LIBVA_DRIVER_NAME,nvidia"
                      "XDG_SESSION_TYPE,wayland"
                      "GBM_BACKEND,nvidia-drm"
                      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                      "WLR_NO_HARDWARE_CURSORS,1"
                      "XDG_CURRENT_DESKTOP,Hyprland"
                      "XDG_SESSION_DESKTOP,Hyprland"
                    ];
                };
              };
              no-picom = {
                services.picom.enable = lib.mkForce false;
              };
            in
            {
              imports = [
                no-picom
                hyprland-maker
                inputs.self.homeModules.considerate
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
    {
      programs.hyprland.enable = true;
    }
    {
      location = {
        latitude = 35.0;
        longitude = 139.0;
      };
    }
  ];
}
