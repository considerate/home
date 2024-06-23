{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker
  ];
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
