{ pkgs, ... }:
let deltaBin =
  "${pkgs.delta}/bin/delta";
in
{
  programs.git.extraConfig = {
    pager = {
      diff = deltaBin;
      log = deltaBin;
      reflog = deltaBin;
      show = deltaBin;
    };
    delta = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
    interactive.diffFilter = "${deltaBin} --color-only --features=interactive";
  };
}
