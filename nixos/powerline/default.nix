{
  nixpkgs.overlays = [
    (final: prev: {
      powerline-go = prev.powerline-go.overrideAttrs
        (old: {
          # patches = [ ./powerline-go.diff ];
        });
    })
  ];
}
