{ lib, config, ... }:
let
  overlayType = lib.mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };
  cfg = config.nixpkgs;
in
{
  options = {
    nixpkgs.overlays = lib.mkOption {
      type = lib.types.listOf overlayType;
    };
  };
}
