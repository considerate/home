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
      blame = deltaBin;
    };
    delta = {
      navigate = true;
      line-numbers = true;
      side-by-side = false;
    };
    interactive.diffFilter = "${deltaBin} --color-only --features=interactive";
  };
}
