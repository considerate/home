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
    wireless = { enable = false; };
    useDHCP = false;
    networkmanager = {
      enable = true;
    };
  };
}
