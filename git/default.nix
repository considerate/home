{ pkgs, ... }:
let
in
{
  home.packages = [
    pkgs.gitg
  ];
  programs = {
    git = {
      enable = true;
      userName = "Viktor Kronvall";
      userEmail = "viktor.kronvall@gmail.com";
      ignores = [ "tags" "*.bak" "worktree" ".envrc" ];
      extraConfig = {
        commit.verbose = true;
        push.default = "current";
        merge.tool = "fugitive";
        alias.diff-img = "difftool -t image-diff";
        difftool.image-diff.cmd = ''exec 10>out ; ${pkgs.imagemagick}/bin/compare $REMOTE $LOCAL png:- | ${pkgs.imagemagick}/bin/montage -geometry 400x -font Liberation-Sans -label 'reference' $LOCAL -label 'diff' - -label 'current--%f' $REMOTE /dev/fd/10; ${pkgs.sxiv}/bin/sxiv /dev/fd/10'';
        mergetool.fugitive.cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';
      };
    };
  };
}
