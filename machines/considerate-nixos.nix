inputs:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    {
      system.stateVersion = "22.05";
    }
    inputs.nixos-hardware.nixosModules.dell-xps-13-7390
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    inputs.self.nixosModules.borg
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
      boot.initrd.availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

      programs.kdeconnect.enable = true;
      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
      boot.kernelModules = [ "kvm-intel" ];
      boot.kernelParams = [ "mem_sleep_default=deep" ];
      hardware.enableRedistributableFirmware = true;
      hardware.video.hidpi.enable = true;
      services.thermald.enable = true;
      console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      systemd.services.NetworkManager-wait-online = {
        wantedBy = [ "network-online.target" ];
        enable = false;
      };
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      nix.settings.max-jobs = lib.mkDefault 8;

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/9d293b12-f6ed-4bda-8859-6e8deec532f5";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/35E4-15F5";
        fsType = "vfat";
      };
      environment.systemPackages = [
        pkgs.apfs-fuse
        pkgs.sshfs
        pkgs.hfsprogs
        pkgs.bindfs
        pkgs.jellyfin-media-player
      ];
      fileSystems."/mnt/windows" = {
        device = "/dev/disk/by-label/windows";
        fsType = "ntfs-3g";
      };

      swapDevices =
        [{ device = "/dev/disk/by-uuid/a1993cdb-2a9d-4be5-a517-1b17e8fb7554"; }];
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
      networking.firewall.allowedTCPPorts = [ 22 ];
      age.secrets.wireguard.file = ../secrets/wireguard.age;
      networking.wg-quick.interfaces = {
        ch = {
          autostart = false;
          address = [ "10.67.190.117/32" "fc00:bbbb:bbbb:bb01::4:be74/128" ];
          dns = [ "193.138.218.74" ];
          privateKeyFile = config.age.secrets.wireguard.path;

          peers = [
            {
              publicKey = "/iivwlyqWqxQ0BVWmJRhcXIFdJeo0WbHQ/hZwuXaN3g=";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "193.32.127.66:51820";
              persistentKeepalive = 25;
            }
          ];
        };
        se = {
          autostart = false;
          address = [ "10.67.190.117/32" "fc00:bbbb:bbbb:bb01::4:be74/128" ];
          dns = [ "193.138.218.74" ];
          privateKeyFile = config.age.secrets.wireguard.path;

          peers = [{
            endpoint = "185.65.135.71:51820";
            publicKey = "4nOXEaCDYBV//nsVXk7MrnHpxLV9MbGjt+IGQY//p3k=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            persistentKeepalive = 25;
          }];
        };
      };

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "virtualbox"
        "intel-ocl"
        "spotify"
        "spotify-unwrapped"
        "Oracle_VM_VirtualBox_Extension_Pack"
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
        inputs.agenix.defaultPackage.x86_64-linux
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
