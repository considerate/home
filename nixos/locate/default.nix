{ pkgs, ... }:
{
  services.locate = {
    enable = true;
    locate = pkgs.plocate;
  };
}
