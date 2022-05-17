{ config, pkgs, ... }:

{
  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        # for USB support
        enableExtensionPack = true;
      };
    };
  };
}
