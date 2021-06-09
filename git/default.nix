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
        diff.tool = "${pkgs.ydiff}/bin/ydiff -s";
        mergetool.fugitive.cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';
      };
    };
  };
}
