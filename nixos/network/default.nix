{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
  networking = {
    firewall = {
      enable = true;
    };
    useDHCP = false;
    networkmanager = {
      enable = true;
    };
  };
}
