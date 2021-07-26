{ nixosConfig, lib, ... }:
{
  options.considerate.desktop = lib.mkOption {
    default = nixosConfig.considerate.desktop or false;
    description = "Whether to enable desktop features";
    example = true;
    type = lib.types.bool;
  };
}
