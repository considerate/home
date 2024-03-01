inputs:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    {
      system.stateVersion = "24.05";
    }
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    #inputs.self.nixosModules.battery
    #inputs.self.nixosModules.boot
    #inputs.self.nixosModules.i18n
    #inputs.self.nixosModules.network
    #inputs.self.nixosModules.nix
    #inputs.self.nixosModules.packages
    #inputs.self.nixosModules.passwords
    #inputs.self.nixosModules.powerline
    #inputs.self.nixosModules.redshift
    #inputs.self.nixosModules.ssh
    #inputs.self.nixosModules.tex
    #inputs.self.nixosModules.trackpad
    #inputs.self.nixosModules.xserver
    #inputs.self.nixosModules.display-manager
    {
      boot.loader.systemd-boot.enable = true;
    }
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
    ({ pkgs, lib, ... }: {
      hardware.enableRedistributableFirmware = true;
      services.thermald.enable = true;
      console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      systemd.services.NetworkManager-wait-online = {
        wantedBy = [ "network-online.target" ];
        enable = false;
      };
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      nix.settings.max-jobs = lib.mkDefault 8;

      environment.systemPackages = [
        pkgs.apfs-fuse
        pkgs.sshfs
        pkgs.hfsprogs
        pkgs.bindfs
        pkgs.jellyfin-media-player
      ];
    })
    ({ pkgs, lib, config, ... }: {

      nix.registry = lib.mapAttrs (name: flake: { inherit flake; }) {
        inherit (inputs) nixpkgs home-manager;
      };
      nixpkgs.config.overlays = [
        (final: prev: {
          nsxiv = inputs.nixpkgs-unstable.legacyPackages.${final.system}.nsxiv;
        })
      ];
      services.sshd.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 3000 ];

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "intel-ocl"
        "spotify"
        "spotify-unwrapped"
      ];

      hardware.opengl.enable = true;
      hardware.opengl.driSupport = true;
      hardware.opengl.driSupport32Bit = true;
      services.usbmuxd.enable = true;
      age.identityPaths = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      environment.systemPackages = [
        inputs.agenix.packages.x86_64-linux.agenix
        pkgs.youtube-dl
        pkgs.ffmpeg
        pkgs.vlc
      ];
    })
    {
      time = {
        timeZone = "Asia/Tokyo";
      };
      location = {
        latitude = 35.0;
        longitude = 139.0;
      };
    }
  ];
}
