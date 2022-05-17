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

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Use nix 2.4
    package = pkgs.nix_2_4;
    extraOptions = ''
      experimental-features = flakes nix-command
      keep-outputs = true
      keep-derivations = true
    '';
    # package = pkgs.nixUnstable;
    trustedUsers = [ "root" "considerate" ];
    binaryCachePublicKeys = [
      # considerate cachix
      "considerate.cachix.org-1:qI1u8kAd+aovY5qxCgby2OJhfp7ZMVwCt6JyT2V6rfM="
    ];
  };
}
