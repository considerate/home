{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {
      withNerdIcons = true;
    };
    extraPackages = [
      pkgs.ffmpegthumbnailer
      pkgs.sxiv
      pkgs.mediainfo
    ];
    plugins = {
      src = pkgs.nnn.src + "/plugins";
      mappings = {
        c = "fzcd";
        o = "fzopen";
        f = "finder";
        m = "autojump";
        v = "imgview";
        p = "preview-tui";
        t = "preview-tabbed";
      };
    };
  };
}
