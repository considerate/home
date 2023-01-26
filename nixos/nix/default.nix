{ pkgs, lib, ... }: {
  nixpkgs =
    {
      config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "spotify"
          "spotify-unwrapped"
        ];
        autoOptimiseStore = true;
        allowAliases = true; # Disable when gcc10 builds
        glibc = { installLocales = true; };
      };
    };

  environment.systemPackages = [
    pkgs.nix-output-monitor
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Pick up remote builders from /etc/nix/machines
    distributedBuilds = true;
    settings = {
      trusted-users = [ "root" "considerate" ];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        # considerate cachix
        "considerate.cachix.org-1:qI1u8kAd+aovY5qxCgby2OJhfp7ZMVwCt6JyT2V6rfM="
      ];
    };
    extraOptions = ''
      experimental-features = flakes nix-command
      keep-outputs = true
      keep-derivations = true
    '';

  };
}
