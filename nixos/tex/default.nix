{ pkgs, ... }:
let
  considerate-texlive = with pkgs;
    (texlive.combine {
      inherit (texlive)
        todonotes cleveref beamer beamertheme-metropolis biblatex blindtext
        csquotes emptypage logreq media9 ocgx2 pgfopts scheme-medium titlesec
        wrapfig;
    }).overrideAttrs (old: {
      postBuild = (old.postBuild or "") + ''
        rm $out/bin/purifyeps
      '';
    });
in
{
  environment.systemPackages = [
    considerate-texlive
    pkgs.biber
  ];
}
