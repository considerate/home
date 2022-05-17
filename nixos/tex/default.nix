{ pkgs, ... }:
let
  considerate-texlive = with pkgs;
    texlive.combine {
      inherit (texlive)
        beamer beamertheme-metropolis biblatex blindtext csquotes emptypage
        logreq media9 ocgx2 pgfopts scheme-medium titlesec wrapfig;
    };
in
{
  environment.systemPackages = [
    considerate-texlive
    pkgs.biber
  ];
}
