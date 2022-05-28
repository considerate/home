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
      pkgs.autojump
      pkgs.bat
      pkgs.mpv
      pkgs.tabbed
      pkgs.st
      pkgs.xdotool
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
