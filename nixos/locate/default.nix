{ pkgs, ... }:
{
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };
}
