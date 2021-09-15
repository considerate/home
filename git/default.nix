{ pkgs, lib, ... }:
let
in
{
  home.packages = [
    pkgs.gitg
  ];
  programs = {
    git =
      let
        image-diff = pkgs.writeScript "image-diff.sh" ''
          tmpfile=$(mktemp -t image-diff.XXXXXXX);
          function cleanup() {
             rm -f "$tmpfile"
          };
          trap cleanup EXIT;
          ${pkgs.imagemagick}/bin/compare $1 $2 png:- | ${pkgs.imagemagick}/bin/montage -geometry 400x -font Liberation-Sans -label 'reference' $2 -label 'diff' - -label 'current--%f' $1 "$tmpfile";
          ${pkgs.sxiv}/bin/sxiv "$tmpfile"
        '';
      in
      {
        enable = true;
        userName = "Viktor Kronvall";
        userEmail = "viktor.kronvall@gmail.com";
        ignores = [ "tags" "*.bak" "worktree" ".envrc" ];
        extraConfig = {
          commit.verbose = true;
          push.default = "current";
          merge.tool = "fugitive";
          alias.diff-img = "difftool -t image-diff";
          difftool.image-diff.cmd = "${image-diff} $REMOTE $LOCAL";
          mergetool.fugitive.cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';
        };
      };
  };
}
