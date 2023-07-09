{ config, pkgs, ... }:

{
  virtualisation = {
    virtualbox = {
      host = {
        enable = false;
        # for USB support
        enableExtensionPack = true;
      };
    };
  };
}
