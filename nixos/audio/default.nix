{ pkgs, ... }:
{
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    # extraConfig = ''
    #   load-module module-echo-cancel source_name=noechosource sink_name=noechosink
    #   set-default-source noechosource
    #   set-default-sink noechosink
    # '';
  };
}
