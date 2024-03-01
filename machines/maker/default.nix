inputs:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    {
      system.stateVersion = "22.05";
    }
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    inputs.self.nixosModules.borg
    inputs.self.nixosModules.docker
    inputs.self.nixosModules.default
    ({ pkgs, ... }: {
      programs.fish.enable = true;
      users = {
        users = {
          considerate = {
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
          considerate = {
            imports = [ inputs.self.homeModules.considerate ];
            considerate.desktop = true;
          };
        };
      };
    })
    ({ pkgs, lib, ... }: {
      boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

      boot.kernelModules = [ "kvm-intel" ];
      boot.kernelParams = [ "mem_sleep_default=deep" ];
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
      age.secrets.wireguard.file = ../secrets/wireguard.age;

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "intel-ocl"
        "spotify"
        "spotify-unwrapped"
        "Oracle_VM_VirtualBox_Extension_Pack"
        "slack"
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
        pkgs.slack
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
