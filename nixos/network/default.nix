{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
  networking = {
    firewall = {
      enable = true;
    };
    hostName = "considerate-nixos";
    wireless = { enable = true; };
    useDHCP = false;
    networkmanager = {
      enable = true;
    };
  };
}
