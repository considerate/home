{ config, lib, pkgs, ... }:
let
  inherit (pkgs) fetchurl;
  configFile = pkgs.writeText "config.def.h" (builtins.readFile ./config.h);
  myst = pkgs.st.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ pkgs.harfbuzz ];
    # the themed_cursor patch requires libXcursor to be linked
    preBuild = (old.preBuild or "") + ''
      makeFlagsArray+=(CFLAGS="-I${pkgs.xorg.libXcursor.dev}/include" LDFLAGS="-L${pkgs.xorg.libXcursor}/lib -lXcursor")
    '';
    patches = old.patches ++ [
      ./considerate.diff
    ];
  });
in
{
  home.packages = lib.optionals config.considerate.desktop [ myst ];
}
