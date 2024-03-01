{ pkgs, ... }: {
  boot = {
    consoleLogLevel = 4;
    loader = {
      systemd-boot = { enable = true; };
      # efi = { canTouchEfiVariables = true; };
    };
    plymouth = {
      enable = true;
      logo = pkgs.fetchurl {
        url = "https://nixos.org/logo/nixos-hires.png";
        sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
      };
    };

    tmp.cleanOnBoot = true;
  };
}
