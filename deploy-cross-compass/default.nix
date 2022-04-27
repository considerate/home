{ pkgs, config, lib, ... }:
let
  cfg = config.deploy-cross-compass;
  deploy-cross-compass = pkgs.callPackage ./deploy.nix {
    inherit (cfg) keyPath machines;
  };
in
{
  options.deploy-cross-compass.keyPath = lib.mkOption {
    type = lib.types.str;
    default = "~/.ssh/github";
  };
  options.deploy-cross-compass.machines = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "jarjar.xc"
      "chewbacca.xc"
      "anakin.xc"
      "pichanaki.xc"
      "bobafett.xc"
    ];
  };
  config = {
    home.packages = [ deploy-cross-compass ];
  };
}
