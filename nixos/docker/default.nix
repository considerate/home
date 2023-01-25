{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker
  ];
  users.users.considerate.extraGroups = [ "docker" ];
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
